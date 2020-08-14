import glob
import pandas as pd
import sys
import csv

csv.field_size_limit(9999999)

known_sink_reps = []
known_sink_func_dict = dict()

unknown_sink_reps = []
recall_events = []
nosql_known_worse_events = []
for f in glob.glob(r"C:\Users\saika\projects\ql\constraintsolving\data\*\*sinks-sql.prop.csv"):
    df = pd.read_csv(f)
    reprs = list(df[df["q"] == "SqlInjectionWorse"]["repr"])
    for r in reprs:
        known_sink_reps = known_sink_reps + r.split("::")

    reprs = list(df[df["q"] == "SqlInjection"]["repr"])
    for r in reprs:
        unknown_sink_reps = unknown_sink_reps + r.split("::")
    nosql_known_worse_events = nosql_known_worse_events + list(df[df["q"] == "SqlInjection"]["URL for nd"])
    recall_events += list(set(df[df["q"] == "SqlInjection"]["URL for nd"]).difference(set(df[df["q"] == "SqlInjectionWorse"]["URL for nd"])))

recall_reps = list(set(unknown_sink_reps).difference(known_sink_reps))

repr_file_dict = dict()
repr_dict = dict()
recalled_reps = []
print("Reading sinks")
for f in glob.glob("data/*/*tsmworse-filtered-avg.prop.csv"):
    if f.split("\\")[1] not in open("sqlinjection.txt").read():
        continue
    print(f)
    df=pd.read_csv(f, engine='python')
    file_dict = repr_file_dict.get(f, dict())
    # out of the ones
    predicted_reps = df[(df["score"] > 0) & (df["URL for node"].isin(recall_events))]["rep"]
    for r in predicted_reps:
        parts = r.split("::")
        for p in parts:
            recalled_reps += [p]

    reps=list(df["rep"])
    for r in reps:
        parts = r.split("::")
        for p in parts:
            repr_dict[p] = repr_dict.get(p, 0) + 1
            file_dict[p] = file_dict.get(p, 0) + 1

    repr_file_dict[f] = file_dict

# greedy algorithm
print("sorted events")
sorted_events = sorted(repr_dict.keys(), key=lambda x: repr_dict[x])
covered_events = []

#exit(0)
print(len(recall_events))
print(len(set(recalled_reps)))
print(len(set(recall_reps)))
print(len(set(recalled_reps).intersection(set(recall_reps))))
m=[]
# for k in set(recalled_reps).intersection(set(recall_reps)):
#     for f in repr_file_dict.keys():
#         mm = repr_file_dict[f].get(k, 0)
#         if mm > 100:
#             print(k, mm, f)
#         m = m + [mm]
# import numpy as np
# print(m)
# print(max(m))
# print(np.mean(m))
sorted_reprs = sorted(repr_dict.keys(), key=lambda x : repr_dict[x], reverse=True)
cumulative=0
i=0


with open("repToEventMapping_sql.txt", "w") as repfile:
    for s in sorted_reprs:
        cumulative += repr_dict[s]
        i+=1
        repfile.write("{0}::{1}::{2}::{3}::".format(s, repr_dict[s], cumulative, i))
        if s in known_sink_reps:
            repfile.write("Known")
        elif s in unknown_sink_reps:
            repfile.write("Unknown")
        else:
            repfile.write("Other")
        repfile.write("\n")


