import glob
import os
import pandas as pd
import csv
import sys
import argparse
import logging
from orchestration import global_config
from typing import List


def getProjectNameFromFile(f: str, working_dir) -> str:
    """
    Helper funcion that obtains a project name from a project file name
    """
    f = f.replace(working_dir+"/data/","", 1)
    f=f.replace("\\","/")
    #f=f.replace('\n', '').replace('\r', '')
    # e.g.  LondonMaeCompany_ldpproto_fe04304 -> LondonMaeCompany/ldpproto 
    projectName = '/'.join(f.split("/")[0].replace("_","/").split("/")[:-1])  
    #print(projectName)
    return projectName

def generate_metris(projectList: List[str], working_directory:str, combined:bool, kind:str = ""):
    """
    Given a list of project names, produces the recall and precision metrics 
    To compute recall it uses as ground trought the different between and old (Vworse) and current query (V0)
    Lets call that difference 'new_nodes'. The recall is computed by checking how many of the new_nodes appear
    in the nodes computed by the TSMWorseScores{query_type}. 
    A threshold is used to filter infered nodes with low score.
    Let's call this set TP. Recall is #TP/#new_nodes 
    To compute presicion TP is compared against the set of nodes predicted using TSM (getTSMWorseFilteredQuery)   
    """
    d=dict()
    # Get the list of nodes (csv files) from the analyzed projects 
    # Each DB-tsmworse-ind-avg.prop.csv comes for the query getTSMWorseScoresQuery
    # getTSMWorseScoresSql gets the nodes (sinks, in this case) that are in QueryV0 but not in QueryVWorse
    # So that would be the nodes of the set (QueryV0 - QueryVWorse) intersection QVTSM 
    print("Threshold, true_predicted/total=recall, predicted_known/total_predicted, true_predicted/total_predicted=precision, F1")
    for version in ['worse']:
        # VWorse is the baseline version of the query  to compare against 
        # V0 is the last version of the query
        # V0 - VWorse = elements discovered in last version that doesn't appear in baseline
        suffix = ""        
        if(combined):
            logging.info('Using combined file')
            suffix = "-combined"
        
        csvFiles = glob.glob("{1}/data/*/*tsm{0}-ind-avg{2}{3}.prop.csv".format(version, working_directory, suffix, kind), recursive=True)
        #print("CVSs", csvFiles)
        projectsToAnalyzeRecall = list(filter(lambda projectName: getProjectNameFromFile(projectName, working_dir) in projectList, csvFiles))
        #print("Projects to analyze:", projectsToAnalyzeRecall)
        # Get the list of nodes (csv files) from the analyzed projects 
        # Each DB-tsmworse-filtered-avg.prop.csv comes for the query getTSMWorseFilteredQuery
        # getTSMWorseFilteredQuery...yields nodes (sinks in this case) from QueryVTSM that 
        # are sink candidates, including info about whether they are known sinks and/or effective sinks 
        csvFiles = glob.glob("{1}/data/*/*tsm{0}-filtered-avg{2}{3}.prop.csv".format(version, working_directory, suffix, kind), recursive=True)
        projectsToAnalyzePrecision = list(filter(lambda projectName: getProjectNameFromFile(projectName, working_dir) in projectList, csvFiles))

        logging.info(f"Projects for recall: {projectsToAnalyzeRecall}")
        logging.info(f"Projects for precision: {projectsToAnalyzePrecision}")

        thresholds = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7,0.8, 0.9] 
        #[0.26, 0.27,0.28]
        for threshold in thresholds:
            print(threshold, end=",")
            true_predicted=0
            total=0
            logging.info(f"Analyzing threshold: {threshold}")
            for projectFileName in projectsToAnalyzeRecall:
                logging.info(f"Analyzing recall of: {projectFileName} for threshold {threshold}")
                try:
                    data=pd.read_csv(projectFileName)
                    # data=pd.read_csv(projectFileName, encoding='utf8')
                except Exception as e: 
                    logging.warning(f"Failed to read: {projectFileName}\n{e}")
                    continue

                #projectID = projectFileName.split("/")[1]
                projectID = getProjectNameFromFile(projectFileName, working_dir)

                predicted = 0
                if len(data.index) > 0:
                    predicted = len(data[data["score"] > threshold])
                    true_predicted += predicted
                    d[projectID] = predicted
                else:
                    logging.warning(f"{projectFileName} has zero elements")
                    d[projectID] = 0

                totalForProject = len(data["URL for node"])
                total += totalForProject 
                logging.info("Recall: {0} : {1}/{2}".format(projectID, predicted, totalForProject))
            
            # true_predicted are all nodes whose score>threshold
            # tolal is the number of elements in the tsm_[version]_ind_... file => (V0-VWorse) = new_nodes
            recall = true_predicted / (total + 1e-9)
            print("{1}/{2}={3:.3f}".format(version, true_predicted, total, recall), end=',')

            filtered = 0
            candidates = 0
            total_predicted = 0
            unknown = 0
            predicted_known = 0

            for projectFileName in projectsToAnalyzePrecision:
                try:
                    data=pd.read_csv(projectFileName, engine='python')
                    #data=pd.read_csv(projectFileName, engine='python', encoding='utf8')
                except Exception as e: 
                    logging.warning(f"Failed to read: {projectFileName}\n{e}")
                    continue
                
                logging.info(f"Analyzing precision for: {projectFileName} for threshold {threshold}")
                #projectID = projectFileName.split("/")[1]
                projectID = getProjectNameFromFile(projectFileName, working_dir)

                candidatesForProject = len(data)
                candidates += candidatesForProject

                cur_predicted = len(data[data["score"] > threshold])
                total_predicted += cur_predicted
                # unknownProject = len(data[(data["isKnown"] == False) & (data["filtered"] == False)])
                # unknown += unknownProject
                knownProject = len(data[(data["score"] > threshold) &  (data["isKnown"] == True)])
                predicted_known += knownProject
                logging.info("Precision: {0} : {1}/{2}".format(projectID, d[projectID], cur_predicted))
                logging.info("Known: {0}".format(knownProject))
                # logging.info("Known: {0}  Unkown: {1}".format(knownProject, unknownProject))

    
            print("{0}/{1}".format(predicted_known, total_predicted), end=',')
            precision = true_predicted / (total_predicted + 1e-9)
            print("{0}/{1}={2:.4f}".format(true_predicted, total_predicted, precision), end=',')

            print("{0:.4f}".format((2*precision*recall)/(precision+recall+1e-10)))


"""
Main 
"""

csv.field_size_limit(999999)

parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

parser.add_argument("--project-list", dest="projectListFile", required=False, type=str)
parser.add_argument("--project-name", dest="project", required=False, type=str)
parser.add_argument("--working-dir", dest="working_dir", required=False, type=str)
parser.add_argument("--combined",  action='store_true', help='Use combined scores')
parser.add_argument("--kind",  dest="kind", required=False, default="snk", help='Use combined scores')

parsed_arguments = parser.parse_args()

projectListFile =  parsed_arguments.projectListFile
project =  parsed_arguments.project
working_dir = parsed_arguments.working_dir
combined = parsed_arguments.combined
kind = '-'+parsed_arguments.kind

if project is None and projectListFile is None:
    parser.print_usage()
else:
    if projectListFile is None:
        projectList = [project]
    else:
        with open(projectListFile) as pl:
           projectList = pl.read().splitlines() 
        
if __name__ == '__main__':
    #logging.getLogger().setLevel(logging.WARNING)
    logging.info(f"Project List: {projectList}")
    generate_metris(projectList, working_dir, combined, kind)
