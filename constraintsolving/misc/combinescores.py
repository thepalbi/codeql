import glob
import argparse
import logging
import os
import re
import numpy as np
import pandas as pd



def combine_scores(query, \
                    project_dir=os.path.dirname(os.path.dirname(os.path.realpath(__file__)))):
    
    files=glob.glob(os.path.join(project_dir,"results")+"/*/{0}-*/reprScores.txt".format(query))
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
        scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "src", np.mean(src_dict[k])) for k in src_dict.keys()]))
        scoresfile.write("\nor\n")
        scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "snk", np.mean(snk_dict[k])) for k in snk_dict.keys()]))
        scoresfile.write("\nor\n")
        scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "san", np.mean(san_dict[k])) for k in san_dict.keys()]))





parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")


#parser.add_argument("--project-dir", dest="project_dir", required=True, type=str,
#                    help="Directory of the CodeQL database")
parser.add_argument("--query-name", dest="query_name", required=True, type=str,
                    choices=["NosqlInjectionWorse", "SqlInjectionWorse", "DomBasedXssWorse"],
                    help="Name of the query to solve")

parsed_arguments = parser.parse_args()
#project_dir = os.path.normpath(parsed_arguments.project_dir)
#project_name = os.path.basename(project_dir)
#query = os.environ["QUERY_NAME"]
query_name = parsed_arguments.query_name

if __name__ == '__main__':
    combine_scores(query_name)
