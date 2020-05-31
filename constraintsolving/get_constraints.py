from DataParser import readFlows, readEvents, readKnown
from Variable import Variable
import Constraint
import os

projectdir='eclipse_orion'
outputdir='constraints/{0}'.format(projectdir)
# events = readEvents('data/hadoop/hadoop-eventToReps-at1.prop.csv')
# flows = readFlows('data/hadoop/hadoop-triple-at1.prop.csv', events)
events = readEvents('data/{0}/{0}-eventToReps-at1.prop.csv'.format(projectdir))
flows = readFlows('data/{0}/{0}-triple.prop.csv'.format(projectdir), events)

print("Building constraints...")
constraints=[]
variables=dict()
sanit_sink=dict()
source_sanit=dict()
source_sink=dict()
global_constant_C = 0.75

def getVar(unique_reps, rep, suffix=""):
    return "n{0}_{1}".format(unique_reps.index(rep), suffix)


def getBackOffVar(unique_reps, event, suffix):
    if len(event.reps) > 1:
        return "({0})/{1}".format("+".join([getVar(unique_reps, r, suffix) for r in event.reps]), len(event.reps))
    else:
        return "{0}".format("+".join([getVar(unique_reps, r, suffix) for r in event.reps]))


def printKnownConstraints(event, map:dict):
    with open("{0}/constraints_known.txt".format(outputdir), "a+") as constraintsfile:
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "src"), map.get("src", "0"), Constraint.Constraint.LTE))
        constraintsfile.write("\n")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "src"), map.get("src", "0"), Constraint.Constraint.GTE))
        constraintsfile.write("\n")

        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "san"), map.get("san", "0"), Constraint.Constraint.LTE))
        constraintsfile.write("\n")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "san"), map.get("san", "0"), Constraint.Constraint.GTE))
        constraintsfile.write("\n")

        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "snk"), map.get("snk", "0"), Constraint.Constraint.LTE))
        constraintsfile.write("\n")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "snk"), map.get("snk", "0"), Constraint.Constraint.GTE))
        constraintsfile.write("\n")

def delifexists(f):
    if os.path.exists(f):
        os.remove(f)


delifexists("{0}/constraints_var.txt".format(outputdir))
delifexists("{0}/constraints_flow.txt".format(outputdir))
delifexists("{0}/constraints_known.txt".format(outputdir))
delifexists("{0}/var.txt".format(outputdir))
for flow in flows:
    sanit_sink_tuple = (flow.sanitizer, flow.sink)
    sanit_sink_list = []
    if sanit_sink_tuple in sanit_sink:
        sanit_sink_list = sanit_sink.get(sanit_sink_tuple)
    else:
        sanit_sink[sanit_sink_tuple] = sanit_sink_list
    sanit_sink_list.append(flow.source)


    source_sink_tuple = (flow.source, flow.sink)
    source_sink_list = []
    if source_sink_tuple in source_sink:
        source_sink_list = source_sink.get(source_sink_tuple)
    else:
        source_sink[source_sink_tuple] = source_sink_list

    source_sink_list.append(flow.sanitizer)

    source_sanit_tuple = (flow.source, flow.sanitizer)
    source_sanit_list = []
    if source_sanit_tuple in source_sanit:
        source_sanit_list = source_sanit.get(source_sanit_tuple)
    else:
        source_sanit[source_sanit_tuple] = source_sanit_list

    source_sanit_list.append(flow.sink)

print(len(sanit_sink))
print(len(source_sanit))
print(len(source_sink))

unique_reps=[]
for e in events.keys():
    for rep in events[e].reps:
        unique_reps.append(rep)

unique_reps=list(set(unique_reps))
print("Unique reps: ", len(unique_reps))
# eq 4
for i,rep in enumerate(unique_reps):
    variables["n{0}_src".format(i)]=Variable("n{0}_src".format(i))
    variables["n{0}_san".format(i)] = Variable("n{0}_san".format(i))
    variables["n{0}_snk".format(i)] = Variable("n{0}_snk".format(i))

known_sources=readKnown("data/{0}/{0}-src.prop.csv".format(projectdir))
known_sinks=readKnown("data/{0}/{0}-sinks.prop.csv".format(projectdir))
known_santizers=readKnown("data/{0}/{0}-sanitizers.prop.csv".format(projectdir))

set_sources=0
for src in known_sources:
    if src not in events.keys():
        continue
    printKnownConstraints(events[src], {"src": "1"})

    for rep in events[src].reps:
        if rep not in unique_reps:
            continue
        set_sources+=1
        srcVar = getVar(unique_reps, rep, "src")
        sanVar = getVar(unique_reps, rep, "san")
        snkVar = getVar(unique_reps, rep, "snk")
        # if variables[srcVar].is_constant:
        #     print("{0} already constant".format(srcVar))
        variables[srcVar].set_constant(1.0)
        variables[sanVar].set_constant(0.0)
        variables[snkVar].set_constant(0.0)



set_sinks=0
for sink in known_sinks:
    if sink not in events.keys():
        continue
    printKnownConstraints(events[sink], {"snk": "1"})
    for rep in events[sink].reps:
        if rep not in unique_reps:
            continue
        set_sinks+=1
        srcVar = getVar(unique_reps, rep, "src")
        sanVar = getVar(unique_reps, rep, "san")
        snkVar = getVar(unique_reps, rep, "snk")
        # if variables[snkVar].is_constant:
        #     print("{0} already constant".format(snkVar))
        variables[srcVar].set_constant(0.0)
        variables[sanVar].set_constant(0.0)
        variables[snkVar].set_constant(1.0)


set_san=0
for san in known_santizers:
    if san not in events.keys():
        continue
    printKnownConstraints(events[san], {"san": "1"})
    for rep in events[san].reps:
        if rep not in unique_reps:
            continue
        set_san+=1
        srcVar = getVar(unique_reps, rep, "src")
        sanVar = getVar(unique_reps, rep, "san")
        snkVar = getVar(unique_reps, rep, "snk")
        # if variables[sanVar].is_constant:
        #     print("{0} already constant".format(sanVar))
        variables[srcVar].set_constant(0.0)
        variables[sanVar].set_constant(1.0)
        variables[snkVar].set_constant(0.0)


print(set_sources)
print(set_san)
print(set_sinks)

# output var.txt
with open("{0}/var.txt".format(outputdir), "w") as varfile:
    for v in variables.keys():
        varfile.write(variables[v].print())
        varfile.write("\n")

# output constraints.txt
with open("{0}/constraints_var.txt".format(outputdir), "a+") as constraintsfile:
    for v in variables.keys():
        if not variables[v].is_constant:
            constraintsfile.write(Constraint.print(variables[v].id, "1", Constraint.Constraint.LTE))
            constraintsfile.write("\n")
            constraintsfile.write(Constraint.print(variables[v].id, "0", Constraint.Constraint.GTE))
            constraintsfile.write("\n")





eps_vars=[]
with open("{0}/constraints_flow.txt".format(outputdir), "a+") as constraintsfile:

    for ss in sanit_sink.keys():
        newepsvar = "eps_{0}".format(len(eps_vars))
        eps_vars.append(newepsvar)
        # get rep for each node
        constraintsfile.write(Constraint.print("{0} + {1}".format(getBackOffVar(unique_reps, ss[0], "san"), getBackOffVar(unique_reps, ss[1], "snk")),
                                               "{0} + {1} + {2}".format(" + ".join([getBackOffVar(unique_reps, k, "src") for k in sanit_sink[ss]]), global_constant_C,
                                                                        newepsvar),
                              Constraint.Constraint.LTE))
        constraintsfile.write("\n")

    for ss in source_sanit.keys():
        newepsvar = "eps_{0}".format(len(eps_vars))
        eps_vars.append(newepsvar)
        constraintsfile.write(Constraint.print(
            "{0} + {1}".format(getBackOffVar(unique_reps, ss[0], "src"), getBackOffVar(unique_reps, ss[1], "san")),
            "{0} + {1} + {2}".format(" + ".join([getBackOffVar(unique_reps, k, "snk") for k in source_sanit[ss]]),
                               global_constant_C, newepsvar), Constraint.Constraint.LTE))

        constraintsfile.write("\n")

    for ss in source_sink.keys():
        newepsvar = "eps_{0}".format(len(eps_vars))
        eps_vars.append(newepsvar)
        constraintsfile.write(Constraint.print(
            "{0} + {1}".format(getBackOffVar(unique_reps, ss[0], "src"), getBackOffVar(unique_reps, ss[1], "snk")),
            "{0} + {1} + {2}".format(" + ".join([getBackOffVar(unique_reps, k, "san") for k in source_sink[ss]]),
                               global_constant_C, newepsvar), Constraint.Constraint.LTE))
        constraintsfile.write("\n")


with open("{0}/var.txt".format(outputdir), "a") as varfile:
    for v in eps_vars:
        varfile.write(v+":variable")
        varfile.write("\n")

with open("{0}/constraints_var.txt".format(outputdir), "a") as constraintsfile:
    for v in eps_vars:
        constraintsfile.write(Constraint.print(v, "0", Constraint.Constraint.GTE))
        constraintsfile.write("\n")