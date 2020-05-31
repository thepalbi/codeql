import pandas as pd
from Event import Event
from FlowRelation import FlowRelation


def readEvents(file_loc):
    df=pd.read_csv(file_loc)

    # create events
    events=dict()
    for ind in df.index:
        id=df.loc[ind]["URL for node"]
        if id in events:
            event_obj = events[id]
        else:
            event_obj = Event(id)
            events[id]=event_obj

        rep=df.loc[ind]["str"]
        event_obj.add_rep(rep)

    #print("Total events: %d" % len(events.keys()))
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


def readKnown(file_loc:str):
    df=pd.read_csv(file_loc)
    return list(df["URL for pnd"])


if __name__ == '__main__':
    events=readEvents('data/hadoop/hadoop-eventToReps-at1.prop.csv')
    flows=readFlows('data/hadoop/hadoop-triple-at1.prop.csv', events)
