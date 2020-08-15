from mlmodels.coderepresentationmodel import CodeToNameRepresentationModel

import numpy as np
import torch
from dpu_utils.codeutils import split_identifier_into_parts
import pandas as pd
import re
from annoy import AnnoyIndex
import os
import json
from sklearn.cluster import KMeans, DBSCAN
import glob
import numpy as np
import sys
query="nosqlinjection"
max_distance = 1.23
rtype="src"
knowntype="src"
model_path='models/subtoken-nbow.pkl.gz'

query_info = {
    "nosqlinjection" :
        {
            "scores_file": r"C:\Users\saika\projects\ql\constraintsolving\misc\allscores_nosqlinjectionworse_avg_wosan2.txt",
            "prefix" : "nosql",
            "repfile" : r"C:\Users\saika\projects\ql\constraintsolving\constraints\combined\NosqlInjectionWorse-1596564994\repToID.txt",
            "known" : "NosqlInjection",
            "unknown" : "NosqlInjectionWorse"
        },
    "sqlinjection" :
        {
            "scores_file": r"C:\Users\saika\projects\ql\constraintsolving\misc\allscores_sqlinjectionworse_avg.txt",
            "prefix" : "sql",
            "repfile" : r"C:\Users\saika\projects\ql\constraintsolving\constraints\*\SqlInjectionWorse-*\repToID.txt",
            "known" : "SqlInjection",
            "unknown" : "SqlInjectionWorse"
        }
}

model, nn = CodeToNameRepresentationModel.restore_model(model_path, device="cpu")
embeddings=nn._modules['_CodeToNameModule__code_encoder']._NBowSummaryEncoderModule__embeddings
vocab=model._CodeToNameRepresentationModel__code_encoder._CodeQlNBoWEncoderModel__base_model.vocabulary
scores_file = open(query_info[query]["scores_file"]).readlines()


def distance(word1, word2):
    subtokens1 = split_identifier_into_parts(word1)
    subtokens2 = split_identifier_into_parts(word2)
    print(subtokens2)
    dist = []
    for st1 in subtokens1:
        for st2 in subtokens2:
            cosinesim=torch.nn.CosineSimilarity(dim=1)
            cdist = cosinesim(embeddings(torch.LongTensor([vocab.get_id_or_unk(st1)])),
                              embeddings(torch.LongTensor([vocab.get_id_or_unk(st2)])))
            dist.append(cdist)            
    return max(dist), dist

def getembedding(word):
    subtokens=split_identifier_into_parts(word)
    e=sum([embeddings(torch.LongTensor([vocab.get_id_or_unk(w)]))[0] for w in subtokens])
    return e/sum(e)

def cluster(u, scores, prefix):
    model = DBSCAN(eps=0.7, min_samples=2, metric='precomputed')
    print("Reading reps")
    indices = json.loads(open("index.txt").read())
    funcnames = list(indices.values())
    print("getting embeddings %d" % len(funcnames))
    #X = np.array([getembedding(f).detach().numpy() for f in funcnames])
    if os.path.exists("distances_{0}.pkl.npy".format(prefix)):
        X = np.load("distances_{0}.pkl.npy".format(prefix))
    else:
        print("Computing distances")
        X = np.zeros([len(indices.keys()), len(indices.keys())])
        # pool=multiprocessing.Pool(4)
        # X = pool.map(lambda X:  u.get_distance(int(X[0]), int(X[1])), [(i,j) for j in indices.keys() for i in indices.keys()])
        # X = np.array(X)
        # print(X.shape)
        for i in indices.keys():
            for j in indices.keys():
                X[int(i), int(j)] = u.get_distance(int(i), int(j))
        np.save("distances_{0}.pkl".format(prefix), X)
    print("fitting")

    yhat = model.fit_predict(X)
    cluster_centers = np.unique(yhat)
    print("clusters %d" % len(cluster_centers))
    clusters = []
    with open("clusters_{0}.txt".format(prefix), "w") as clusterfile:
        for cluster in cluster_centers:
            ind = np.where(yhat == cluster)[0]
            clusters.append(ind)
            print("cluster: {0} size: {1}".format(cluster, len(ind)))
            for i in ind:
                print((funcnames[i], list(filter(lambda x : x[0] == funcnames[i], scores))), end=",")
            if cluster != -1:
                for i in ind:
                    clusterfile.write(funcnames[i]+",")
            print()
            clusterfile.write("\n")
    return clusters


# Annoy uses Euclidean distance of normalized vectors for its angular distance, which for two
# vectors u,v is equal to sqrt(2(1-cos(u,v)))
def load_or_build_index(prefix, repFilePath, embedding_size=128):
    model_path = "index_{0}.ann".format(prefix)
    if not os.path.exists(model_path):
        print("Reading reps")
        repFiles = glob.glob(repFilePath, recursive=True)
        li= []
        for f in repFiles:
            df = pd.read_csv(f, header=None)
            li.append(df)
        df = pd.concat(li, axis=0, ignore_index=True)
        #params = df[df[0].str.match("^\(parameter [0-9] \(member ")]
        params = df[df[0].str.match("(.*\(parameter [0-9]+ \(member .*)|(.*\(return \(member .*)")]
        funcnames = list(params[0].str.extract("member ([a-zA-Z0-9_]+)")[0])
        funcnames = set([k for k in funcnames if type(k) == str])
        #params = list(params[0].apply(lambda x: ":".join(x.split(":")[:-1])))
        u = AnnoyIndex(embedding_size, 'angular')
        i = 0
        print("Found functions : ", len(funcnames))
        print("Adding items")
        func_dict=dict()
        for f in funcnames:
            func_dict[i] = f
            u.add_item(i, getembedding(f))
            i += 1
        print("Building")
        u.build(100)
        u.save(model_path)


        with open("index_{0}.txt".format(prefix), "w") as indexfiles:
            indexfiles.write(json.dumps(func_dict))
        indices = func_dict
    else:
        u = AnnoyIndex(embedding_size, 'angular')
        u.load(model_path)
        indices = json.loads(open("index_{0}.txt".format(prefix)).read())

    return u, indices


def predict(model, name_decoder, data):
    all_responses = model.greedy_decode(data, name_decoder, device="cpu")
    print(all_responses)
    return
    print(nn._modules['_CodeToNameModule__code_encoder'].__dict__)
    code_representations = nn.code_encoder(data).cpu()
    predictions = name_decoder.greedy_decode(
        code_representations, model.name_decoder
    )
    print(predictions)


def train_distance(known_reps, all_reps, annoy_index, all_scores_dict, split=0.7):
    # split known into train and test
    train_reps = np.random.choice(known_reps, int(split*len(known_reps)))
    test_reps = [k for k in known_reps if k not in train_reps]
    print("Train: {0}, Test: {1}".format(len(train_reps), len(test_reps)))
    print("Train ", train_reps)
    print("Test ", test_reps)
    train_rep_func_dict = dict()
    for k in train_reps:
        fnames = re.findall("member ([a-zA-Z0-9_]+)", k)
        for fname in fnames:
            train_rep_func_dict[fname] = known_sink_func_dict.get(fname, []) + [k]
    other_reps = list(set(all_reps).difference(set(train_reps)))
    for cur_distance in [0.5, 1.0,  1.2, 1.25, 1.5, 2.0, 2.5, 3.0]:
        # cur_distance = 1.25
        # find a distance which choose most of test without much blow up
        chosen_reps = []

        for t in other_reps:
            fname = all_scores_dict[t][0]
            e = getembedding(fname)
            similar_funcs = annoy_index.get_nns_by_vector(e, 100, include_distances=True)

            similarfnames = [indices[str(similar_funcs[0][i])] for i in range(len(similar_funcs[0])) if
                              indices[str(similar_funcs[0][i])] != fname and similar_funcs[1][i] <= cur_distance]
            #similarfnames = [indices[str(similar_funcs[0][i])] for i in range(len(similar_funcs[0])) if
            #                similar_funcs[1][i] <= cur_distance]

            for sf in similarfnames:
                if sf in train_rep_func_dict.keys():
                    chosen_reps = chosen_reps + [t]
                    break
                    #print(">>", k, fname, scores_dict[k][1])
                    #print(sf, known_sink_func_dict.get(sf))

        test_recalled = set(chosen_reps).intersection(set(test_reps))
        precision = len(set(chosen_reps).intersection(set(test_reps)))/(len(set(chosen_reps)) + 1e-6)
        recall = len(set(chosen_reps).intersection(set(test_reps)))/(len(set(test_reps)) + 1e-6)
        f1 = (2*precision*recall)/(precision+recall+1e-6)
        print("Distance: {3} , Precision : {0}, Recall : {1}, F1 : {2}".format(precision, recall, f1, cur_distance))
        print("Chosen reps: {0}, Test Recalled : {1}".format(len(chosen_reps), len(test_recalled)))

u, indices = load_or_build_index(query_info[query]["prefix"], query_info[query]["repfile"])
#predict(model, nn, ["exec"])


scores = []

scores_dict = dict()
for line in scores_file:
    if "\"{0}\"".format(rtype) in line:
        repr = re.findall("repr = \"([^\"]+)\"", line)[0]
        score = float(re.findall("result = ([0-9.]+)", line)[0])
        #fname="None"
        # if repr.startswith("(parameter "):
        fname=re.findall("member ([a-zA-Z0-9_]+)", repr)
        if len(fname) > 0:
            fname=fname[0]
        else:
            fname="None"
        if fname != "None":
            #print(fname, score, repr)
            scores.append((fname, score, repr))
            scores_dict[repr] = [fname, score]
print("Functions: %d" % len(indices.keys()))

known_sink_reps = []
known_sink_func_dict = dict()

unknown_sink_reps = []

for f in glob.glob(r"C:\Users\saika\projects\ql\constraintsolving\data\*\*{1}-{0}.prop.csv".format(query_info[query]["prefix"], knowntype)):
    df = pd.read_csv(f)
    reprs = list(df[df["q"] == query_info[query]["unknown"]]["repr"])
    for r in reprs:
        known_sink_reps = known_sink_reps + r.split("::")
    reprs = list(df[df["q"] == query_info[query]["known"]]["repr"])
    for r in reprs:
        unknown_sink_reps = unknown_sink_reps + r.split("::")


known_sink_reps = list(set(known_sink_reps))
print("Known reps: {0}".format(len(known_sink_reps)))
#print(known_sink_reps)
unknown_sink_reps = list(set(unknown_sink_reps) - set(known_sink_reps))
#print(unknown_sink_reps)
print("Unknown reps: {0}".format(len(unknown_sink_reps)))
for k in known_sink_reps:
    fnames = re.findall("member ([a-zA-Z0-9_]+)", k)
    for fname in fnames:
        known_sink_func_dict[fname] = known_sink_func_dict.get(fname, []) + [k]

train_distance(known_sink_reps, list(scores_dict.keys()), u, scores_dict, split=0.7)
exit(1)

predicted=0
predicted_reprs = []
notpredicted=0
stringmatch=0
notstringmatch=0
predicted_and_match = []
predicted_and_known = []
with open("filtered_reps_{0}_src.txt".format(query_info[query]["prefix"]), "w") as ff:
    for k in scores_dict.keys():
        if scores_dict[k][1] > 0 and k not in known_sink_reps:
            fname = scores_dict[k][0]
            e = getembedding(fname)
            similar_funcs = u.get_nns_by_vector(e, 100, include_distances=True)

            detected = False

            similarfnames = [indices[str(similar_funcs[0][i])] for i in range(len(similar_funcs[0]))
                             if indices[str(similar_funcs[0][i])] != fname and similar_funcs[1][i] <= max_distance]

            sc=[]
            for sf in similarfnames:
                if sf in known_sink_func_dict:
                    detected = True
                    print(">>", k, fname, scores_dict[k][1])
                    print(sf, known_sink_func_dict.get(sf))

                    sc = sc + known_sink_func_dict.get(sf)

            if detected:
                stringmatch+=1
                ff.write("repr=\"{0}\" and t=\"{1}\" and result={2} or\n".format(k, rtype, scores_dict[k][1]))
            else:
                notstringmatch+=1
            if k in known_sink_reps:
                if detected:
                    predicted_and_known += [k]
            if k in unknown_sink_reps:
                predicted_reprs += [k]
                predicted += 1
                if detected:
                    predicted_and_match += [k]
                else:
                    notpredicted+=1
print(stringmatch, notstringmatch)
print(predicted, notpredicted)
print("Predicted and matched : {0}".format(len(predicted_and_match)))
print("Predicted and known : {0}".format(len(predicted_and_known)))

print(predicted_reprs)
exit(1)
# clusters = []
# for f in list(indices.values()):
#     e=getembedding(f)
#     similar = u.get_nns_by_vector(e, 10, include_distances=True)

for s in scores:
    funcname=s[0]
    e=getembedding(funcname)
    print(funcname)

    similar = u.get_nns_by_vector(e, 50, include_distances=True)
    print(similar)
    print([indices[str(s)] for s in similar[0] if indices[str(s)] != funcname])
