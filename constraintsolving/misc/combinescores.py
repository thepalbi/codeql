import glob
import os
import re
import numpy as np
import pandas as pd

query = os.environ["QUERY_NAME"]

files=glob.glob("../results/*/{0}-*/reprScores.txt".format(query))


files.sort(key=os.path.getmtime)
n=0
allreps=[]
src_dict = dict()
snk_dict = dict()
san_dict = dict()
file_src_reprs = dict()
file_snk_reprs = dict()
file_san_reprs = dict()
for f in files:
    if r'results\combined' not in f:
        print(f)
        file_src_reprs[f] = []
        file_snk_reprs[f] = []
        file_san_reprs[f] = []
        n+=1
        for l in open(f).readlines():
            repr=re.findall("repr = \"([^\"]+)\"", l)[0]
            t=re.findall("t = \"([^\"]+)\"", l)[0]
            res=float(re.findall("result = ([0-9.]+)", l)[0])
            #print(l.strip())
            #print(repr, t, res)
            if t == "src":
                src_dict[repr] = src_dict.get(repr, []) + [res]
                file_src_reprs[f] = file_src_reprs.get(f, []) + [repr]
            if t == "snk":
                snk_dict[repr] = snk_dict.get(repr, []) + [res]
                file_snk_reprs[f] = file_snk_reprs.get(f, []) + [repr]
            if t == "san":
                san_dict[repr] = san_dict.get(repr, []) + [res]
                file_san_reprs[f] = file_san_reprs.get(f, []) + [repr]


print(n)


print(len(src_dict), len(snk_dict), len(san_dict))
with open("allscores_{0}_avg.txt".format(query), "w") as scoresfile:
    scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "src", np.mean(src_dict[k])) for k in src_dict.keys()]))
    scoresfile.write("\nor\n")
    scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "snk", np.mean(snk_dict[k])) for k in snk_dict.keys()]))
    scoresfile.write("\nor\n")
    scoresfile.write(" or\n".join(["repr = \"{0}\" and t = \"{1}\" and result = {2}".format(k, "san", np.mean(san_dict[k])) for k in san_dict.keys()]))