import pandas as pd
from Event import Event
from FlowRelation import FlowRelation
import multiprocessing
import traceback as tb
import re
from typing import List

def remapRepsToClusters(reps):
    clustersdata = open(r"C:\Users\saika\projects\adaptive-thread-modelling-gnn\clusters.txt").readlines()
    clusters = dict()
    function_map = dict()
    for cluster in clustersdata:
        functions = cluster.split(",")
        # clusters[functions[0]] = list(filter(lambda x: len(x.strip()) > 0, functions))
        for f in functions:
            if len(f) > 0:
                # considering 0 as cluster center
                function_map[f] = functions[0]

    for rep in reps:
        newrep = re.findall("parameter [0-9]+ \(member ([a-zA-Z0-9_]+)|return ")

    pass


def readEvents(file_loc, events=None, unique_reps=None, rep_count=None, ctx=dict()):
    print("Reading events from: ", file_loc)
    df=pd.read_csv(file_loc)

    # create events
    if events is None:
        events=dict()
    cur_reps=set(list(df["repr"]))
    new_reps=cur_reps.difference(set(events.keys()))
    print("New events: %d" % len(new_reps))
    for rep in new_reps:
        event_obj = Event(rep, reps=rep.strip().split("::"))
        events[rep] = event_obj
    new_unique_reps = [r.strip().split("::") for r in new_reps]
    # Flattens the new_unique_reps, and makes a diff
    new_unique_reps = set([i for g in new_unique_reps for i in g]).difference(set(unique_reps.keys()))
    print("New Unique reps: %d" % len(new_unique_reps))
    print(list(new_unique_reps)[:5])
    i = len(list(unique_reps.keys()))
    for k in new_unique_reps:
        unique_reps[k] = i
        # TODO: assuming representation does not match partially with others
        # rep_count[k] = rep_count.get(k, 0) + len(list(df[df["repr"].str.contains(k, regex=False)]))
        i += 1
        # if unique_reps is not None:
        #     for r in rep.strip().split("::"):
        #         if r not in unique_reps:
        #             unique_reps[r]=len(list(unique_reps.keys()))
    # for ind in df.index:
    #     id=df.loc[ind]["repr"]
    #     if id not in events:
    #         event_obj = Event(id, reps=id.strip().split("::"))
    #         events[id] = event_obj
    #         if unique_reps is not None:
    #             for r in id.strip().split("::"):
    #                 if r not in unique_reps:
    #                     unique_reps[r]=len(list(unique_reps.keys()))

    print("Total events: %d" % len(events.keys()))
    return events


def readFlows(file_loc:str, events: dict):
    df=pd.read_csv(file_loc)
    flows=[]
    error_ids=[]
    for ind in df.index:
        srcid=df.loc[ind]["URL for src"]
        sanid = df.loc[ind]["URL for san"]
        snkid = df.loc[ind]["URL for snk"]
        try:
            flow_obj=FlowRelation(events[srcid], events[sanid], events[snkid])
            flows.append(flow_obj)
        except KeyError as k:
            error_ids.append(k.args[0])

    #print("Total flows: %d" % len(flows))
    #print("Not found: %d" % len(error_ids))
    #print(error_ids[:5])
    return flows


def getevent(id, events, reps):
    if id not in events.keys():
        events[id] = Event(id)
        for r in id.split("::"):
            reps.append(r)
            events[id].add_rep(r)
    return events[id]


def mp(func, data, events):
    with multiprocessing.Pool(4) as p:
        results = p.map(lambda x: func(events, x), data)
    return results

def f(events, tup, flows):
    row=tup
    srcid = row["ssrc"]
    sanid = row["ssan"]
    snkid = row["ssnk"]
    try:
        flow_obj = FlowRelation(events[srcid], events[sanid], events[snkid])
        flows.append(flow_obj)
    except:
        tb.print_exc()


def readFlowsAndReps(file_loc:str, events) -> List[FlowRelation]:
    df=pd.read_csv(file_loc)
    flows = []
    error_ids = []
    print("Starting flows")
    # results = mp(f, df.iterrows(), events)
    # print("Results %d" % len(results))
    # for r in results:
    #     flows = flows + r
    df.apply(lambda x: f(events, x, flows), axis=1)
    # for ind in df.index:
    #     srcid =  df.loc[ind]["ssrc"]
    #     sanid = df.loc[ind]["ssan"]
    #     snkid = df.loc[ind]["ssnk"]
    #     try:
    #         flow_obj = FlowRelation(events[srcid], events[sanid], events[snkid])
    #         flows.append(flow_obj)
    #     except KeyError as k:
    #         error_ids.append(k.args[0])
    print("Done flows")
    return flows

def readPairs(file_loc:str, events):
    df = pd.read_csv(file_loc)
    return df


def readKnown(file_loc:str, suffix:str, query) -> List[str]:
    print("Reading known from: ", file_loc)
    print("Query: ", query)

    df=pd.read_csv(file_loc)
    print("Unique {0} locations: {1}, reps: {2} ".format(suffix,len(list(set(df["URL for nd"]))), len(list(set(df["repr"])))))

    if query is None:
        return list(set(df["repr"]))
    else:
        print("Unique Query {0} locations: {1} ".format(suffix, len(list(set(df[df["q"] == query]["repr"])))))
        return list(set(df[df["q"] == query]["repr"]))


def readURL(file_loc:str):
    df=pd.read_csv(file_loc)
    col=list(filter(lambda x: x.startswith('URL'), list(df)))
    assert(len(col) == 1)
    col=col[0]
    return list(df[col])

def readClass(file_loc:str):
    df=pd.read_csv(file_loc)
    eventclass=dict()
    for ind in df.index:
        d=eventclass.get(df.loc[ind]["URL for pnd"], list())
        d.append(df.loc[ind]["q"])
        eventclass[df.loc[ind]["URL for pnd"]] = d
    return eventclass

if __name__ == '__main__':
    #events=readEvents('data/hadoop/hadoop-eventToReps-at1.prop.csv')
    flows, events, reps=readFlowsAndReps('data/eclipse_orion/eclipse_orion-triple-id.prop.csv')
    print(len(flows))
    print(len(events))
    print(len(reps))
