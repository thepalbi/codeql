import glob
import os
import pandas as pd
import csv
import sys

def getProjectNameFromFile(f):
    f=f.replace("\\","/")
    # e.g.  LondonMaeCompany_ldpproto_fe04304 -> LondonMaeCompany/ldpproto 
    projectName = '/'.join(f.split("/")[1].replace("_","/").split("/")[:-1])  
    #print(projectName)
    return projectName

projectListFile = sys.argv[1]
projectList = open(projectListFile).read()

csv.field_size_limit(999999)
d=dict()
for threshold in [0.26, 0.27,0.28]:
    print(threshold, end=",")
    for version in ['worse']:
        true_predicted=0
        total=0
        csvFiles = glob.glob("data/*/*tsm{0}-ind-avg.prop.csv".format(version), recursive=True)
        for f in csvFiles:
            projectName = getProjectNameFromFile(f)
            if projectName not in projectList:
                continue
            try:
                #print("trying to read\n")
                data=pd.read_csv(f)
                #print("Data: ", data)
            except:
                #print("Failed to read: ", f)
                continue
            if len(data.index) > 0:
                p = len(data[data["score"] > threshold])
                true_predicted += p
                d[f.split("/")[1]] = p
            else:
                d[f.split("/")[1]] = 0

            total += len(data["URL for node"])
            #print("Recall: {0} : {1}/{2}".format(os.path.basename(os.path.dirname(f)),len(data[data["score"] > threshold]),len(data["URL for node"])))
            #print(os.path.dirname(f))
            #print(len(open(glob.glob(os.path.dirname(f) + "/*atm-worse.prop.csv")[0]).readlines()))
        #print("NoSQL V{0}: {1}/{2}={3:.2f}".format(version,predicted, total, predicted/(total+1e-9)))
        recall = true_predicted / (total + 1e-9)
        print("{1}/{2}={3:.3f}".format(version, true_predicted, total, recall), end=',')

        filtered = 0
        candidates = 0
        total_predicted = 0
        unknown = 0
        predicted_known = 0

        csvFiles = glob.glob("data/*/*tsm{0}-filtered-avg.prop.csv".format(version), recursive=True)
        #print("CSV Files:", csvFiles)
        for f in csvFiles:
            f = f.replace("\\", "/")
            projectName = getProjectNameFromFile(f)
            if projectName not in projectList:
                continue
            try:
                data=pd.read_csv(f, engine='python')
                print(data)
            except:
                print("Failed to read: ", f)
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

        print("{0}/{1}".format(predicted_known, total_predicted), end=',')
        precision = true_predicted / total_predicted
        print("{0}/{1}={2:.4f}".format(true_predicted, total_predicted, precision), end=',')

        print("{0:.4f}".format((2*precision*recall)/(precision+recall+1e-10)))
