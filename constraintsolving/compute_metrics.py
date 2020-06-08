import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score




def getmetrics(actual, predicted, c):
    # Precision
    scores=dict()
    scores["actual"]=sum(actual)
    scores["predicted"]=sum(predicted)
    scores["precision"]=precision_score(actual, predicted)
    scores["recall"]=recall_score(actual, predicted)
    scores["f1"]=f1_score(actual, predicted)
    #return "{0:.2f}/{1:.2f}/{2:.2f}".format(scores["precision"], scores["recall"], scores["f1"])
    # print(c)
    # print("Actual true %d" % sum(actual))
    # print("Predicted true %d" % sum(predicted))
    # print("Precision " ,precision_score(actual, predicted))
    # print("Recall ", recall_score(actual, predicted))
    # print("F1 ", f1_score(actual, predicted))
    return scores


def printmetrics(trainingsize, threshold):
    scores=[]
    for trial in [1,2,3]:
        events = open("constraints/eclipse_orion/eventToRepIDs.txt").readlines()
        results = open("models/eclipse_orion/results_gb_{0}_{1}.txt".format(trainingsize, trial)).readlines()
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
                srcscores+=vars[r+"_src"]
                snkscores+=vars[r+"_snk"]
                sanscores+=vars[r+"_san"]
            eventScores[name + ":src"] = srcscores / len(reps)
            eventScores[name + ":san"] = sanscores / len(reps)
            eventScores[name + ":snk"] = snkscores / len(reps)
            allevents.append(name)
            allevents2[name]=reps

        # with open("models/eclipse_orion/eventscores.txt", "w") as scoresfile:
        #     for k in eventScores.keys():
        #         scoresfile.write(k+":"+str(eventScores[k]))
        #         scoresfile.write("\n")

        sinks=[k.split(",")[1].strip().replace('"', '') for k in open("data/eclipse_orion/eclipse_orion-sinks.prop.csv").readlines()[1:]]
        sources=[k.split(",")[1].strip().replace('"', '') for k in open("data/eclipse_orion/eclipse_orion-src.prop.csv").readlines()[1:]]
        sans=[k.split(",")[1].strip().replace('"', '') for k in open("data/eclipse_orion/eclipse_orion-sanitizers.prop.csv").readlines()[1:]]

        predictedsinks=[k.replace(":snk", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":snk" in k]
        predictedsources=[k.replace(":src", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":src" in k]
        predictedsans=[k.replace(":san", "") for k in eventScores.keys() if eventScores[k] >= threshold and ":san" in k]

        sourcemetrics = getmetrics([1 if e in sources else 0 for e in allevents],
                                   [1 if e in predictedsources else 0 for e in allevents], "sources")
        snkmetrics=getmetrics([1 if e in sinks else 0 for e in allevents],
                              [1 if e in predictedsinks else 0 for e in allevents], "sinks")
        sanitizermetrics=getmetrics([1 if e in sans else 0 for e in allevents],
                                    [1 if e in predictedsans else 0 for e in allevents], "sanitizers")
        scores.append((sourcemetrics, snkmetrics, sanitizermetrics))
    return ("{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[0]["precision"] for s in scores]), np.mean([s[0]["recall"] for s in scores]), np.mean([s[0]["f1"] for s in scores])),
            "{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[1]["precision"] for s in scores]), np.mean([s[1]["recall"] for s in scores]), np.mean([s[1]["f1"] for s in scores])),
            "{0:.2f}/{1:.2f}/{2:.2f}".format(np.mean([s[2]["precision"] for s in scores]), np.mean([s[2]["recall"] for s in scores]), np.mean([s[2]["f1"] for s in scores])),
            )


for trainingsize in [0.1]:
    srcstr = "src"
    snkstr = "snk"
    sanstr = "san"
    print(trainingsize)
    for thresh in [0.9]:
        src,snk,san=printmetrics(trainingsize, thresh)
        srcstr=srcstr+"&"+src
        snkstr=snkstr+"&"+snk
        sanstr=sanstr+"&"+san
    print(srcstr+"\\\\")
    print(sanstr+"\\\\")
    print(snkstr+"\\\\")
# for k in eventScores.keys():
#     if eventScores[k] < threshold:
#         continue
#     if ":san" in k:
#         if k.replace(":san", "") in sans:
#             correctsans+=1
#     if ":src" in k:
#         if k.replace(":src", "") in sources:
#             correctsources+=1
#     if ":snk" in k:
#         if k.replace(":snk", "") in sinks:
#             correctsinks+=1
# print(correctsources)
# print(correctsans)
# print(correctsinks)
# print("Precision src: {0}, san: {1}, snk: {2}".format(correctsources/(len(totalsources), correctsans/(len(totalsources)+0.0001), correctsinks/len(totalsinks)))
