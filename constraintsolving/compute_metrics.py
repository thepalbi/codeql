import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score
from DataParser import readKnown
# dirprefix="C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"
from solver.config import SolverConfig
from orchestration import global_config
from orchestration.steps import RESULTS_DIR_KEY, CONSTRAINTS_DIR_KEY, MODELS_DIR_KEY, RESULTS_DIR_KEY
import os
import logging
import shutil

def getmetrics(actual, predicted, c):
    # Precision
    scores=dict()
    scores["actual"]=sum(actual)
    scores["predicted"]=sum(predicted)
    scores["precision"]=precision_score(actual, predicted)
    scores["recall"]=recall_score(actual, predicted)
    scores["f1"]=f1_score(actual, predicted)
    return scores


def printmetrics(trainingsize, config: SolverConfig, ctx):
    lambda_const = config.lambda_const 
    trials = config.trials

    scores=[]
    _src = "s"
    _san = "a"
    _snk = "i"
    event_to_rep_id_path = os.path.join(ctx[CONSTRAINTS_DIR_KEY], "eventToRepIDs.txt")
    rep_to_id_path = os.path.join(ctx[CONSTRAINTS_DIR_KEY], "repToID.txt")

    for trial in range(1, trials+1):
        logging.info("Reading: {0}".format(event_to_rep_id_path))
        events = open(event_to_rep_id_path,'r', errors='replace', encoding='utf-8').readlines()
        results = open(f"{ctx[MODELS_DIR_KEY]}/results_gb_{trainingsize}_{lambda_const}_{trial}.txt", encoding='utf-8').readlines()
        reprs = open(rep_to_id_path,'r', errors='replace', encoding='utf-8').readlines()
        vars = dict()
        for r in results:
            vars[r.split(":")[0]]=float(r.split(":")[1])
        eventScores=dict()
        allevents=[]
        allevents2=dict()
        for e in events:
            #print("Event: ", e)                
            name=":".join(e.split(":")[:-1])

            # check if the event has associated variables
            if e.find(":n")>=0:
                reps=e.split(":")[-1].split(",")
                srcscores=0.0
                snkscores=0.0
                sanscores=0.0
                for r in reps:
                    r=r.strip()
                    #print("Rep: ", r)
                    srcscores+=vars[r+_src]
                    snkscores+=vars[r+_snk]
                    sanscores+=vars[r+_san]
                eventScores[name + ":src"] = srcscores / len(reps)
                eventScores[name + ":san"] = sanscores / len(reps)
                eventScores[name + ":snk"] = snkscores / len(reps)
            else: 
                reps = []
                eventScores[name + ":src"] = 0
                eventScores[name + ":san"] = 0
                eventScores[name + ":snk"] = 0
            allevents.append(name)
            allevents2[name]=reps

        # with open("models/eclipse_orion/eventscores.txt", "w") as scoresfile:
        #     for k in eventScores.keys():
        #         scoresfile.write(k+":"+str(eventScores[k]))
        #         scoresfile.write("\n")

        # sinks=[k.split(",")[1].strip().replace('"', '') for k in open("data/{0}/{0}-sinks.prop.csv".format(projectdir)).readlines()[1:]]
        # sources=[k.split(",")[1].strip().replace('"', '') for k in open("data/{0}/{0}-src.prop.csv".format(projectdir)).readlines()[1:]]
        # sans=[k.split(",")[1].strip().replace('"', '') for k in open("data/{0}/{0}-sanitizers.prop.csv".format(projectdir)).readlines()[1:]]
        #
        # sinks = readKnown("data/{0}/{0}-sinks-cls.prop.csv".format(projectdir), "sinks", query)
        # sources = readKnown("data/{0}/{0}-src-cls.prop.csv".format(projectdir), "src", query)
        # sans = readKnown("data/{0}/{0}-sanitizers-cls.prop.csv".format(projectdir), "san", query)

        # sinks = []
        # sources = []
        # sans = []
        # for k in constraints_builder.known_sinks:
        #     sinks = sinks + constraints_builder.known_sinks[k]
        # for k in constraints_builder.known_sanitizers:
        #     sans = sans + constraints_builder.known_sanitizers[k]
        # for k in constraints_builder.known_sources:
        #     sources = sources + constraints_builder.known_sources[k]

        #predictedsinks=[k.replace(":snk", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":snk" in k]
        #predictedsources=[k.replace(":src", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":src" in k]
        #predictedsans=[k.replace(":san", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":san" in k]
        # print(eventScores)
        # print(len(predictedsinks))
        # exit(0)
        # with open("results/{0}/newsinks.txt".format(outputdir), "w") as newsinks:
        #     for snk in predictedsinks:
        #         if snk not in sinks:
        #             #newsinks.write(snk.replace("file:///", "file:///{0}".format(dirprefix)).replace("js:", "js#L"))
        #             newsinks.write(snk)
        #             newsinks.write("\n")
        #
        # with open("results/{0}/newsrcs.txt".format(outputdir), "w") as newsrcs:
        #     for src in predictedsources:
        #         if src not in sources:
        #             #newsrcs.write(src.replace("file:///", "file:///{0}".format(dirprefix)).replace("js:", "js#L"))
        #             newsrcs.write(src)
        #             newsrcs.write("\n")
        #
        # with open("results/{0}/newsans.txt".format(outputdir), "w") as newsans:
        #     for san in predictedsans:
        #         if san not in sans:
        #             #newsans.write(san.replace("file:///", "file:///{0}".format(dirprefix)).replace("js:", "js#L"))
        #             newsans.write(san)
        #             newsans.write("\n")

            #print("Repr set size: ", len(reprs))
        repConstraints = []    
        for repr in reprs:
            if repr.find(":n")>=0:
                repid=repr.split(":")[-1].strip()
                rep=":".join(repr.split(":")[0:-1])
                #print(repid, vars[repid+_src],' ', vars[repid+_snk], ' ', vars[repid+_san] )
                reprToWrite = None
                #print("rep,", repr)
                #print("repid,", repid)
                if vars[repid+_src] > 0.0:
                    reprToWrite = "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "src", "%.10f" 
    %  vars[repid + _src])

                if vars[repid+_snk] > 0.0:
                    reprToWrite = "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "snk", "%.10f" 
    %  vars[repid + _snk])

                if vars[repid+_san] > 0.0:
                    reprToWrite= "repr = \"{0}\" and t = \"{1}\" and result = {2}".format(rep, "san", "%.10f" 
    % vars[repid + _san ])

            if reprToWrite is not None:
                repConstraints.append(reprToWrite)

        
        repr_scores_file_path = os.path.join(ctx[RESULTS_DIR_KEY], "reprScores.txt")
        logging.info("Writing reprScores: {0}".format(repr_scores_file_path))

        with open(repr_scores_file_path, "w", encoding='utf-8') as reprscores:
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


def getallmetrics(config: SolverConfig, ctx):
    metrics_file_path = os.path.join(ctx[RESULTS_DIR_KEY], "metrics.txt")
    with open(metrics_file_path, "w") as metricsfile:
        for trainingsize in config.trainingsizes:
            srcstr = "src"
            snkstr = "snk"
            sanstr = "san"
            metricsfile.write("{0}\n".format(trainingsize))
            for thresh in config.thresholds:
                src, snk, san = printmetrics(trainingsize, config, ctx)
                srcstr=srcstr+"&"+src
                snkstr=snkstr+"&"+snk
                sanstr=sanstr+"&"+san
            metricsfile.write(srcstr+"\\\\\n")
            metricsfile.write(sanstr+"\\\\\n")
            metricsfile.write(snkstr+"\\\\\n")

def createReprPredicate(ctx, project_name:str, query_type:str, reprScoresFiles = "reprScores.txt"):
    tsm_query_folder = os.path.join(global_config.sources_root, "javascript", "ql", "src", "TSM", "query")
    tsm_repr_pred_file = os.path.join(tsm_query_folder, "tsm_repr_pred.qll")
    repr_scores_path = os.path.join(ctx[RESULTS_DIR_KEY], reprScoresFiles)

    print(tsm_repr_pred_file)
    print(repr_scores_path)
    with open(repr_scores_path, "r", encoding='utf-8') as reprscores:
        with open(tsm_repr_pred_file , "w", encoding='utf-8') as reprPrFile:
            reprPrFile.writelines([
                "module TsmRepr {",
                "float getReprScore(string repr, string t){\n"])
            reprscores = reprscores.readlines()
            if len(reprscores)>0:
                reprPrFile.writelines(reprscores)
            else:
                reprPrFile.write('\t result = 0 and (t = "src" or t = "snk" or t = "san") and repr = ""\n')
            reprPrFile.writelines(["}","}"])
    # create a TSM query in the results dir
    createTSMQuery(ctx, project_name, query_type)

def createTSMQuery(ctx, project_name: str, query_type: str):
    tsm_folder = os.path.join(global_config.sources_root, "javascript", "ql", "src", "TSM")
    tsm_query_folder = os.path.join(tsm_folder, "query")
    tsm_repr_pred_file = os.path.join(tsm_query_folder, "tsm_repr_pred.qll")
    tsm_query = os.path.join(tsm_query_folder, "TSM.ql")
    tsm_query_qll = os.path.join(tsm_query_folder, "tsm.qll")
    # for tsm_config we use one query tailed for query_type
    # this is essentially because we currently filter sanitizers by query and not by score  
    tsm_config = os.path.join(tsm_folder, query_type, "tsm_config.qll")

    query_dir = os.path.join(tsm_query_folder, query_type, project_name, os.path.basename(ctx[RESULTS_DIR_KEY]))
    print(query_dir)
    if not os.path.exists(query_dir):
        os.makedirs(query_dir)
    shutil.copy(tsm_repr_pred_file,query_dir )
    shutil.copy(tsm_query,query_dir )
    shutil.copy(tsm_query_qll, query_dir)
    shutil.copy(tsm_config, query_dir)
    


        




if __name__ == '__main__':
    dirprefix = "C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"
    projectdir = 'eclipse_orion'
    #getallmetrics(projectdir, dirprefix, [1], [0.9], 0.1, 1, "DomBasedXss")
