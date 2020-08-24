import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score
from DataParser import readKnown
# dirprefix="C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"
from solver.config import SolverConfig


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

        with open("results/{0}/reprScores.txt".format(outputdir), "w") as reprscores:
            for repr in reprs:
                repid=repr.split(":")[-1].strip()
                rep=":".join(repr.split(":")[0:-1])
                if vars[repid+_src] > 0.0:
                    reprscores.write(
                        "repr = \"{0}\" and t = \"{1}\" and result = {2} or \n".format(rep, "src",
                                                                                   vars[repid + _src]))
                if vars[repid+_snk] > 0.0:
                    reprscores.write(
                        "repr = \"{0}\" and t = \"{1}\" and result = {2} or \n".format(rep, "snk",
                                                                                   vars[repid + _snk]))

                if vars[repid+_san] > 0.0:
                    reprscores.write(
                        "repr = \"{0}\" and t = \"{1}\" and result = {2} or \n".format(rep, "san",
                                                                                   vars[repid + _san ]))

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


if __name__ == '__main__':
    dirprefix = "C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"
    projectdir = 'eclipse_orion'
    #getallmetrics(projectdir, dirprefix, [1], [0.9], 0.1, 1, "DomBasedXss")
