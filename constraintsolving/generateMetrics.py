import glob
import os
import pandas as pd
import csv
import sys
import argparse
import logging


def getProjectNameFromFile(f):
    f=f.replace("\\","/")
    # e.g.  LondonMaeCompany_ldpproto_fe04304 -> LondonMaeCompany/ldpproto 
    projectName = '/'.join(f.split("/")[1].replace("_","/").split("/")[:-1])  
    #print(projectName)
    return projectName

def generate_metris(projectList):
    d=dict()
    for threshold in [0.26, 0.27,0.28]:
        print(threshold, end=",")
        # VWorse is the baseline version of the query  to compare against 
        # V0 is the last version of the query
        # V0 - VWorse = elements discovered in last version that doesn't appear in baseline
        for version in ['worse']:
            true_predicted=0
            total=0
            # Get the list of nodes (csv files) from the analyzed projects 
            # Each DB-tsmworse-ind-avg.prop.csv comes for the query getTSMWorseScoresQuery
            # getTSMWorseScoresSql gets the nodes (sinks, in this case) that are in QueryV0 but not in QueryVWorse
            # So that would be the nodes of the set (QueryV0 - QueryVWorse) intersection QVTSM 
            csvFiles = glob.glob("data/*/*tsm{0}-ind-avg.prop.csv".format(version), recursive=True)
            projectsToAnalyze = filter(lambda projectName: getProjectNameFromFile(projectName) in projectList, csvFiles) 
            for projectFileName in projectsToAnalyze:
                #print("Analyzing: ", projectName)
                try:
                    #print("trying to read\n")
                    data=pd.read_csv(projectFileName)
                    #print("Data: ", data)
                except:
                    print("Failed to read: ", projectFileName)
                    continue

                projectID = projectFileName.split("/")[1]
                #print(projectID)

                if len(data.index) > 0:
                    p = len(data[data["score"] > threshold])
                    true_predicted += p
                    d[projectID] = p
                else:
                    d[projectID] = 0

                total += len(data["URL for node"])
                #print("Recall: {0} : {1}/{2}".format(os.path.basename(os.path.dirname(f)),len(data[data["score"] > threshold]),len(data["URL for node"])))
                #print(os.path.dirname(f))
                #print(len(open(glob.glob(os.path.dirname(f) + "/*atm-worse.prop.csv")[0]).readlines()))
            #print("NoSQL V{0}: {1}/{2}={3:.2f}".format(version,predicted, total, predicted/(total+1e-9)))
            
            # true_predicted are all nodes whose score>threshold
            # tolal is the number of elements in the tsm_[version]_ind_... file  
            recall = true_predicted / (total + 1e-9)
            print("{1}/{2}={3:.3f}".format(version, true_predicted, total, recall), end=',')

            filtered = 0
            candidates = 0
            total_predicted = 0
            unknown = 0
            predicted_known = 0

            # Get the list of nodes (csv files) from the analyzed projects 
            # Each DB-tsmworse-filtered-avg.prop.csv comes for the query getTSMWorseFilteredSqlQuery
            # getTSMWorseFilteredSqlQuery...yields nodes (sinks in this case) from QueryVTSM that 
            # are sink candidates, includinf info about whether they are known sinks and/or effective sinks 
            csvFiles = glob.glob("data/*/*tsm{0}-filtered-avg.prop.csv".format(version), recursive=True)
            projectsToAnalyze = filter(lambda projectName: getProjectNameFromFile(projectName) in projectList, csvFiles) 
            for projectFileName in projectsToAnalyze:
                try:
                    data=pd.read_csv(projectFileName, engine='python')
                    #print(data)
                except:
                    print("Failed to read: ", projectFileName)
                    continue
                #if len(data.index) > 0:
                #    filtered += len(data[(data["score"] > threshold) & (data["filtered"] == True) & (data["isKnown"] == False)])
                #candidates += len(data)
                #print(len(data[data["score"] > threshold]))
                cur_predicted = len(data[data["score"] > threshold])
                total_predicted += cur_predicted
                #unknown += len(data[(data["isKnown"] == False) & (data["filtered"] == False)])
                predicted_known += len(data[(data["score"] > threshold) &  (data["isKnown"] == True)])
                #print("{0}: {1}/{2} = {3}".format(f.split("/")[-2],d[f.split("/")[1]],
                #                                 cur_predicted, d[f.split("/")[1]]/cur_predicted
                #                                 ))
                #unknown += len(data[(data["isKnown"] == False)])
                #total+=len(set(data["URL for node"]))
                #print(len(set(data["URL for node"])))
                #print(os.path.dirname(f))
                #print(len(open(glob.glob(os.path.dirname(f) + "/*atm-worse.prop.csv")[0]).readlines()))
            #print("Filtered/Predicted: {0}/{1}={2:.2f}".format( filtered, total_predicted, filtered/(total_predicted+1e-9)))
            #print("{0}/{1}={2:.2f}".format( filtered, total_predicted, filtered/(total_predicted+1e-9)), end=',')
            #print("Predicted/Unknown-Filtered: {0}/{1}={2:.2f}".format(total_predicted, unknown, total_predicted/unknown))
            #print("{0}/{1}={2:.4f}".format(total_predicted, unknown, total_predicted/unknown), end=',')
            #print("Predicted/Candidates: {0}/{1}={2:.2f}".format(total_predicted, candidates, total_predicted / candidates))
            #print("{0}/{1}={2:.4f}".format(total_predicted, candidates, total_predicted / candidates), end=',')

            # true_predicted are all nodes whose score>threshold from getTSMWorseScoresQuery
            # tolal_predicted are all nodes whose score>threshold from getTSMWorseFilteredSqlQuery
            # predicted_known are those from total_predicted are came from known source
            print("{0}/{1}".format(predicted_known, total_predicted), end=',')
            precision = true_predicted / (total_predicted + 1e-9)
            print("{0}/{1}={2:.4f}".format(true_predicted, total_predicted, precision), end=',')

            print("{0:.4f}".format((2*precision*recall)/(precision+recall+1e-10)))






csv.field_size_limit(999999)

parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

#parser.add_argument("--project-dir", dest="project_dir", required=True, type=str,
#                    help="Directory of the CodeQL database")
parser.add_argument("--project-list", dest="projectListFile", required=False, type=str)
parser.add_argument("--project", dest="project", required=False, type=str)

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
    print("Project List:", projectList)
    generate_metris(projectList)
