import glob
import os
import pandas as pd
import sys
import argparse
import logging
import numpy
from typing import List


def processQueryDiffConfig(projectFileName, outputFile):
    repsDict  = dict()
    project = ""
    data = open(projectFileName,'r', errors='replace', encoding='utf-8').readlines()
    print('project, new, missing, same')
    for line in data:
        if line.startswith("\"new\""):
            continue
        if line.startswith("Analyzing"):
            project = line.replace("Analyzing ","").strip()
            continue
        print(project,',', line.strip())


def processQueryReprSinks(projectFileName, outputFile):
    repsProjectDict  = dict()
    repsDict  = dict()
    projectRSDict = dict()
    project = ""
    data = open(projectFileName,'r', errors='replace', encoding='utf-8').readlines()
    for line in data:
        if line.startswith("\"sink\""):
            continue
        if line.startswith("Analyzing"):
            project = line.replace("Analyzing ","").strip()
            continue
        line = line.strip()
        # there are sinks with commas, that complicated the processing  
        columns = line.split(',') 
        #print(line)
        pos = len(columns)-2
        count = int(columns[pos])
        rep = columns[pos+1]

        if rep not in repsProjectDict.keys():
            repsProjectDict[rep] = set()
        repsProjectDict[rep].add(project)
        
        pr = (project, rep) 
        if pr not in projectRSDict.keys():
            projectRSDict[pr] = count
        else: 
            projectRSDict[pr] = projectRSDict[pr] + count    


        if rep not in repsDict.keys():
            repsDict[rep] = count
        else:
            repsDict[rep] = repsDict[rep] + count

        #print(project,', ', line)
    # for project in repsProjectDict.keys():    
    #     print(project, ', ', len(repsProjectDict[project]))
    print('rep,count,projects,w/o outliers, blame')
    sorted_dict = {k: v for k, v in sorted(repsDict.items(), key=lambda item: -item[1])}
    for rep in sorted_dict.keys():
        if rep.startswith("\"") and rep != "\"rep\"":
            projectsCount = len(repsProjectDict[rep])    
            projectCountString = ""
            projectCountDict = dict()
            for project in repsProjectDict[rep]:
                pr = (project, rep) 
                projectCountDict[project] = projectRSDict[pr]
            
            projectCountDict = {k: v for k, v in sorted(projectCountDict.items(), key=lambda item: -item[1])}
            elements = numpy.array(list(projectCountDict.values())) 
            #print(elements)
            mean = numpy.mean(elements) 
            sd = numpy.std(elements)

            final_list = [x for x in projectCountDict.values() if (x > mean - 2 * sd)]
            final_list = [x for x in final_list if (x < mean + 2 * sd)]
            withoutOutliers = sum(final_list)
            projectCountString = str(projectCountDict).replace(',',';')
            print(rep,',',sorted_dict[rep],',', projectsCount,',',withoutOutliers,',',projectCountString)
                

def processQueryReprSinksPerProject(projectFileName, outputFile):
    repsProjectDict  = dict()
    repsDict  = dict()
    project = ""
    data = open(projectFileName,'r', errors='replace', encoding='utf-8').readlines()
    print('rep, count')
    for line in data:
        if line.startswith("\"new\""):
            continue
        if line.startswith("Analyzing"):
            project = line.replace("Analyzing ","").strip()
            repsProjectDict[project] = dict()
            continue
        line = line.strip()
        rep = line.split(',')[2]

        repsPerProject = repsProjectDict[project]
        if rep not in repsDict.keys():
            repsDict[rep] = 1
        else:
            repsDict[rep] = repsDict[rep] + 1

        if rep not in repsPerProject.keys():
            repsPerProject[rep] = 1
        else:
            repsPerProject[rep] = repsPerProject[rep] + 1


        #print(project,', ', line)
    for project in repsProjectDict.keys():    
        print(project, ', ', len(repsProjectDict[project]))
        for rep in repsProjectDict[project].keys():    
            print(rep,',', repsProjectDict[project][rep])

def processQueryUnlikelyRep(projectFileName, outputFile):
    repsDict  = dict()
    project = ""
    data = open(projectFileName,'r', errors='replace', encoding='utf-8').readlines()
    print('rep, projects')
    for line in data:
        if line.startswith("\"rep\""):
            continue
        if line.startswith("Analyzing"):
            project = line.replace("Analyzing ","").strip()
            continue
        line = line.strip()
        rep = line.split(',')[0]
        count = line.split(',')[1]
        if rep not in repsDict.keys():
            repsDict[rep] = set()
        repsDict[rep].add(project) 

        # print(project,',', line)
    sorted_dict = {k: v for k, v in sorted(repsDict.items(), key=lambda item: -len(item[1]))}
    for rep in sorted_dict.keys():    
        print(rep, ',', len(repsDict[rep]))


def processVsReprSinks(projectFileName, outputFile):
    projectRSDict  = dict()
    repsDict  = dict()
    project = ""
    data = open(projectFileName,'r', errors='replace', encoding='utf-8').readlines()
    print('rep, count')
    for line in data:
        if line.startswith("\"sinkNew\""):
            continue
        if line.startswith("Analyzing"):
            project = line.replace("Analyzing ","").strip()
            continue
        line = line.strip()
        sink= line.split(',')[0]
        rep = line.split(',')[1]
        pr = (project, rep) 
        if pr not in projectRSDict.keys():
            projectRSDict[pr] = dict()

        sinkDict = projectRSDict[pr]    
        if sink not in sinkDict.keys():
            sinkDict[sink] = 1
        else:
            sinkDict[sink] = sinkDict[sink] + 1

        if rep not in repsDict.keys():
            repsDict[rep] = 1
        else:
            repsDict[rep] = repsDict[rep] + 1

        #print(project,', ', line)
    oldProject = ""
    for pr in projectRSDict.keys():
        (project, rep) = pr
        sinkDict = projectRSDict[pr]     
        if oldProject != project:
            print(project)
        sinks = list(sinkDict.keys())
        total = sum(sinkDict.values())
        print(rep, ':', sinks,  '=', total)
        oldProject = project
    # for rep in repsDict.keys():    
    #     print(rep,',', repsDict[rep])


parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

parser.add_argument("--input", dest="fileName", required=True, type=str)
parser.add_argument("--kind", dest="kind", required=False, type=str, default="diff",
                    choices=["diff", "repr", "reprProject", "unlikely","vs"],
                    help="Kind of file to process")
parser.add_argument("--output", dest="outputFileName", required=True, type=str)

parsed_arguments = parser.parse_args()

fileName =  parsed_arguments.fileName
outputFileName =  parsed_arguments.outputFileName
kind = parsed_arguments.kind

if kind == 'diff':
    processQueryDiffConfig(fileName, outputFileName)
else: 
    if kind == 'repr':
        processQueryReprSinks(fileName, outputFileName)
    # "/persistent/experiments/nosql/sinks2.txt")
    else: 
        if kind == 'unlikely':
            processQueryUnlikelyRep(fileName, outputFileName)
            #(projectFileName = "/persistent/experiments/nosql/unlikely.txt")
        else: 
            if kind== 'vs':
                processVsReprSinks(fileName, outputFileName)
            else:
                if kind == 'reprProject':
                    processQueryReprSinksPerProject(fileName, outputFileName)

