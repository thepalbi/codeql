import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score
from DataParser import readKnown
from solver.config import SolverConfig
import os

def getmetrics(actual, predicted, c):
    # Precision
    scores=dict()
    scores["actual"]=sum(actual)
    scores["predicted"]=sum(predicted)
    scores["precision"]=precision_score(actual, predicted)
    scores["recall"]=recall_score(actual, predicted)
    scores["f1"]=f1_score(actual, predicted)
    return scores


def printmetrics(outputdir, trainingsize, lambda_const, trials):
    scores=[]
    _src = "s"
    _san = "a"
    _snk = "i"
    for trial in range(1, trials+1):
        events = open("constraints/{0}/eventToRepIDs.txt".format(outputdir)).readlines()
        results = open("models/{0}/results_gb_{1}_{2}_{3}.txt".format(outputdir, trainingsize, lambda_const, trial)).readlines()
        reprs = open("constraints/{0}/repToID.txt".format(outputdir)).readlines()
        vars = dict()
        for r in results:
            vars[r.split(":")[0]]=float(r.split(":")[1])
        eventScores=dict()
        allevents=[]
        allevents2=dict()
        for e in events:
            name=":".join(e.split(":")[:-1])
            reps=e.split(":")[-1].split(",")
            srcscores=0.0
            snkscores=0.0
            sanscores=0.0
            for r in reps:
                r=r.strip()
                srcscores+=vars[r+_src]
                snkscores+=vars[r+_snk]
                sanscores+=vars[r+_san]
            eventScores[name + ":src"] = srcscores / len(reps)
            eventScores[name + ":san"] = sanscores / len(reps)
            eventScores[name + ":snk"] = snkscores / len(reps)
            allevents.append(name)
            allevents2[name]=reps

        repConstraints = []    
        for repr in reprs:
            repid=repr.split(":")[-1].strip()
            rep=":".join(repr.split(":")[0:-1])
            #print(vars[repid+_src],' ', vars[repid+_snk], ' ', vars[repid+_san] )
            reprToWrite = None
            if vars[repid+_src] > 0.0:
                reprToWrite = "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "src", vars[repid + _src])

            if vars[repid+_snk] > 0.0:
                reprToWrite = "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "snk", vars[repid + _snk])

            if vars[repid+_san] > 0.0:
                reprToWrite= "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "san", vars[repid + _san ])

            if reprToWrite is not None:
                repConstraints.append(reprToWrite)

        with open("results/{0}/reprScores.txt".format(outputdir), "w") as reprscores:
            sizeReprSet = len(repConstraints) 
            countRepr = 0     
            for repConstraint in repConstraints:
                countRepr = countRepr + 1
                if countRepr<sizeReprSet:
                    repConstraint=repConstraint +"  or "
                repConstraint = repConstraint + "\n"
                reprscores.write(repConstraint)



        return "", "", ""
        # sourcemetrics = getmetrics([1 if e in sources else 0 for e in allevents],
        #                            [1 if e in predictedsources else 0 for e in allevents], "sources")
        # snkmetrics=getmetrics([1 if e in sinks else 0 for e in allevents],
        #                       [1 if e in predictedsinks else 0 for e in allevents], "sinks")
        # sanitizermetrics=getmetrics([1 if e in sans else 0 for e in allevents],
        #                             [1 if e in predictedsans else 0 for e in allevents], "sanitizers")
        # scores.append((sourcemetrics, snkmetrics, sanitizermetrics))
    return ("{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[0]["precision"] for s in scores]), np.mean([s[0]["recall"] for s in scores]), np.mean([s[0]["f1"] for s in scores])),
            "{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[1]["precision"] for s in scores]), np.mean([s[1]["recall"] for s in scores]), np.mean([s[1]["f1"] for s in scores])),
            "{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[2]["precision"] for s in scores]), np.mean([s[2]["recall"] for s in scores]), np.mean([s[2]["f1"] for s in scores])),
            )


def getallmetrics(outputdir, config:SolverConfig):
    with open("results/{0}/metrics.txt".format(outputdir), "w") as metricsfile:
        for trainingsize in config.trainingsizes:
            srcstr = "src"
            snkstr = "snk"
            sanstr = "san"
            metricsfile.write("{0}\n".format(trainingsize))
            for thresh in config.thresholds:
                src, snk, san = printmetrics(outputdir, trainingsize, config.lambda_const, config.trials)
                srcstr=srcstr+"&"+src
                snkstr=snkstr+"&"+snk
                sanstr=sanstr+"&"+san
            metricsfile.write(srcstr+"\\\\\n")
            metricsfile.write(sanstr+"\\\\\n")
            metricsfile.write(snkstr+"\\\\\n")

def createReprPredicate(outputdir,query_type, query_name):
    tsm_queries_folder = os.path.join(os.environ["CODEQL_SOURCE_ROOT"],"javascript","ql","src")
    output_path = tsm_queries_folder + "/tsm_repr_pred_{0}.qll".format(query_type)
    reprScoreFilename = "results/{0}/reprScores.txt".format(outputdir)

    print(output_path)
    print(reprScoreFilename)
    with open(reprScoreFilename, "r") as reprscores:
        with open(output_path , "w") as reprPrFile:
            reprPrFile.writelines([
                "module TsmRepr {",
                "float getReprScore(string repr, string t){\n"])
            reprscores = reprscores.readlines()
            if len(reprscores)>0:
                reprPrFile.writelines(reprscores)
            else:
                reprPrFile.write('\t result = 0 and (t = "src" or t = "snk" or t = "san") and repr = ""\n')
            reprPrFile.writelines(["}","}"])



        




if __name__ == '__main__':
    dirprefix = "C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"
    projectdir = 'eclipse_orion'
    #getallmetrics(projectdir, dirprefix, [1], [0.9], 0.1, 1, "DomBasedXss")
