import glob
import os
import pandas as pd
import csv
import sys
import argparse
import logging
from typing import List

def getProjectNameFromFile(f: str) -> str:
    """
    Helper funcion that obtains a project name from a project file name
    """
    f=f.replace("\\","/")
    # e.g.  LondonMaeCompany_ldpproto_fe04304 -> LondonMaeCompany/ldpproto 
    projectName = '/'.join(f.split("/")[1].replace("_","/").split("/")[:-1])  
    #print(projectName)
    return projectName

def generate_metris(projectList: List[str]):
    """
    Given a list of project names, produces the recall and precision metrics 
    To compute recall it uses as ground trought the different between and old (Vworse) and current query (V0)
    Lets call that different new_nodes. The recall is computed by checking how many of the new_nodes appear
    in the nodes computes by the TSM query. A threshold is used to filter infered nodes with low score.
    Let's call this set TP. Recall is #TP/#new_nodes 
    To compute presicion TP is compared against the set of nodes predicted using TSM (getTSMWorseFilteredQuery)   
    """
    d=dict()
    # Get the list of nodes (csv files) from the analyzed projects 
    # Each DB-tsmworse-ind-avg.prop.csv comes for the query getTSMWorseScoresQuery
    # getTSMWorseScoresSql gets the nodes (sinks, in this case) that are in QueryV0 but not in QueryVWorse
    # So that would be the nodes of the set (QueryV0 - QueryVWorse) intersection QVTSM 
    for version in ['worse']:
        # VWorse is the baseline version of the query  to compare against 
        # V0 is the last version of the query
        # V0 - VWorse = elements discovered in last version that doesn't appear in baseline
        csvFiles = glob.glob("data/*/*tsm{0}-ind-avg.prop.csv".format(version), recursive=True)
        projectsToAnalyzeRecall = list(filter(lambda projectName: getProjectNameFromFile(projectName) in projectList, csvFiles))
        # Get the list of nodes (csv files) from the analyzed projects 
        # Each DB-tsmworse-filtered-avg.prop.csv comes for the query getTSMWorseFilteredQuery
        # getTSMWorseFilteredSqlQuery...yields nodes (sinks in this case) from QueryVTSM that 
        # are sink candidates, includind info about whether they are known sinks and/or effective sinks 
        csvFiles = glob.glob("data/*/*tsm{0}-filtered-avg.prop.csv".format(version), recursive=True)
        projectsToAnalyzePrecision = list(filter(lambda projectName: getProjectNameFromFile(projectName) in projectList, csvFiles))

        for threshold in [0.26, 0.27,0.28]:
            print(threshold, end=",")
            true_predicted=0
            total=0
            logging.info(f"Analyzing threshold: {threshold}")
            for projectFileName in projectsToAnalyzeRecall:
                logging.info(f"Analyzing recall of: {projectFileName} for threshold {threshold}")
                try:
                    data=pd.read_csv(projectFileName)
                except:
                    print("Failed to read: ", projectFileName)
                    continue

                projectID = projectFileName.split("/")[1]

                predicted = 0
                if len(data.index) > 0:
                    predicted = len(data[data["score"] > threshold])
                    true_predicted += predicted
                    d[projectID] = predicted
                else:
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
                except:
                    print("Failed to read: ", projectFileName)
                    continue
                
                logging.info(f"Analyzing precision for: {projectFileName} for threshold {threshold}")
                projectID = projectFileName.split("/")[1]
        
                candidatesForProject = len(data)
                candidates += candidatesForProject

                cur_predicted = len(data[data["score"] > threshold])
                total_predicted += cur_predicted
                #unknown += len(data[(data["isKnown"] == False) & (data["filtered"] == False)])
                predicted_known += len(data[(data["score"] > threshold) &  (data["isKnown"] == True)])
                logging.info("Precision: {0} : {1}/{2}".format(projectID, d[projectID], cur_predicted))

    
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

parsed_arguments = parser.parse_args()

projectListFile =  parsed_arguments.projectListFile
project =  parsed_arguments.project
if project is None and projectListFile is None:
    parser.print_usage()
else:
    if projectListFile is None:
        projectList = [project]
    else:
        projectList = open(projectListFile).read()

if __name__ == '__main__':
    logging.info(f"Project List: {projectList}")
    generate_metris(projectList)
