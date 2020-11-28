import glob
import argparse
import logging
import os
import re
import numpy as np
import pandas as pd



def combine_scores(query, \
                    project_dir=os.path.dirname(os.path.dirname(os.path.realpath(__file__)))):
    print(project_dir)
    files=glob.glob(os.path.join(project_dir) + "/*/{0}-*/reprScores.txt".format(query))
    files.sort()
    #print(files)
    last_files = list()
    projectsFiles = dict()
    for file in files:
        timestamp = os.path.basename(os.path.dirname(file))
        project = os.path.basename(os.path.dirname(os.path.dirname(file)))
        if project not in projectsFiles.keys():
            projectsFiles[project] = list()
        projectsFiles[project].append(file)
    
    for project in projectsFiles.keys():
        projectsFiles[project].sort(key=os.path.getmtime)
        last_files.append(projectsFiles[project][-1])

    files = last_files
    print(files)
    files.sort(key=os.path.getmtime)
    n=0
    allreps=[]
    src_dict = dict()
    snk_dict = dict()
    san_dict = dict()
    file_src_reprs = dict()
    file_snk_reprs = dict()
    file_san_reprs = dict()
    for reprScoreFile in files:
        if r'results\combined' not in reprScoreFile:
            print(reprScoreFile)
            file_src_reprs[reprScoreFile] = []
            file_snk_reprs[reprScoreFile] = []
            file_san_reprs[reprScoreFile] = []
            n+=1
            for reprScopeLine in open(reprScoreFile).readlines():
                repr=re.findall("repr = \"([^\"]+)\"", reprScopeLine)[0]
                t=re.findall("t = \"([^\"]+)\"", reprScopeLine)[0]
                res=float(re.findall("result = ([0-9.]+)", reprScopeLine)[0])
                #print(l.strip())
                #print(repr, t, res)
                if t == "src":
                    src_dict[repr] = src_dict.get(repr, []) + [res]
                    file_src_reprs[reprScoreFile] = file_src_reprs.get(reprScoreFile, []) + [repr]
                if t == "snk":
                    snk_dict[repr] = snk_dict.get(repr, []) + [res]
                    file_snk_reprs[reprScoreFile] = file_snk_reprs.get(reprScoreFile, []) + [repr]
                if t == "san":
                    san_dict[repr] = san_dict.get(repr, []) + [res]
                    file_san_reprs[reprScoreFile] = file_san_reprs.get(reprScoreFile, []) + [repr]


    print(n)


    print(len(src_dict), len(snk_dict), len(san_dict))
    with open("allscores_{0}_avg.txt".format(query), "w") as scoresfile:
        if len(src_dict)>0:
            scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "src",  "%.10f" 
    % np.mean(src_dict[k])) for k in src_dict.keys()]))
        if len(snk_dict)>0:            
            if len(src_dict)>0:
                scoresfile.write("\nor\n")
            scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "snk",  "%.10f" 
    % np.mean(snk_dict[k])) for k in snk_dict.keys()]))
        if len(san_dict)>0:
            if len(src_dict)>0 or len(snk_dict)>0:
                scoresfile.write("\nor\n")
            scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "san",  "%.10f" 
    % np.mean(san_dict[k])) for k in san_dict.keys()]))





parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")


parser.add_argument("--project-dir", dest="project_dir", required=True, type=str,
                    help="Directory of the results score")
parser.add_argument("--query-name", dest="query_name", required=True, type=str,
                    choices=["NosqlInjectionWorse", "SqlInjectionWorse", "DomBasedXssWorse","TaintedPathWorse"],
                    help="Name of the query to solve")

parsed_arguments = parser.parse_args()
#project_dir = os.path.normpath(parsed_arguments.project_dir)
#project_name = os.path.basename(project_dir)
#query = os.environ["QUERY_NAME"]
query_name = parsed_arguments.query_name
working_dir = parsed_arguments.project_dir
if __name__ == '__main__':
    combine_scores(query_name, working_dir)
