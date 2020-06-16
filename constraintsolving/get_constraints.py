from DataParser import readFlows, readEvents, readKnown, readClass, readURL
from Variable import Variable
import Constraint
import os
import shutil
from config import SolverConfig


def createBlackList(events, sources, sinks):
    # ignoring sanitizers for now
    blacklist=[]
    for source in sources:
        if source not in events:
            continue
        for sink in sinks:
            if sink not in events:
                continue
            source_reps = set(events[source].reps)
            sink_reps = set(events[sink].reps)
            if len(source_reps.intersection(sink_reps)) > 0:
                blacklist.append(source)
                blacklist.append(sink)
    return list(set(blacklist))


def getVar(unique_reps, rep, suffix=""):
    return "n{0}_{1}".format(unique_reps.index(rep), suffix)


def getBackOffVar(unique_reps, event, suffix):
    if len(event.reps) > 1:
        return "({0})/{1}".format("+".join([getVar(unique_reps, r, suffix) for r in event.reps]), len(event.reps))
    else:
        return "{0}".format("+".join([getVar(unique_reps, r, suffix) for r in event.reps]))


def printKnownConstraints(outputdir, event, map:dict, unique_reps):
    with open("{0}/constraints_known_{1}.txt".format(outputdir, list(map.keys())[0]), "a+") as constraintsfile:
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "src"), map.get("src", "0"), Constraint.Constraint.LTE))
        constraintsfile.write(",")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "src"), map.get("src", "0"), Constraint.Constraint.GTE))
        constraintsfile.write(",")

    #with open("{0}/constraints_known_san.txt".format(outputdir), "a+") as constraintsfile:
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "san"), map.get("san", "0"), Constraint.Constraint.LTE))
        constraintsfile.write(",")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "san"), map.get("san", "0"), Constraint.Constraint.GTE))
        constraintsfile.write(",")

    #with open("{0}/constraints_known_snk.txt".format(outputdir), "a+") as constraintsfile:
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "snk"), map.get("snk", "0"), Constraint.Constraint.LTE))
        constraintsfile.write(",")
        constraintsfile.write(
            Constraint.print(getBackOffVar(unique_reps, event, "snk"), map.get("snk", "0"), Constraint.Constraint.GTE))
        constraintsfile.write("\n")


def delifexists(f):
    if os.path.exists(f):
        os.remove(f)


def delete_old_constraints(outputdir):
    delifexists("{0}/constraints_var.txt".format(outputdir))
    delifexists("{0}/constraints_flow.txt".format(outputdir))
    delifexists("{0}/constraints_known.txt".format(outputdir))
    delifexists("{0}/constraints_known_src.txt".format(outputdir))
    delifexists("{0}/constraints_known_san.txt".format(outputdir))
    delifexists("{0}/constraints_known_snk.txt".format(outputdir))
    delifexists("{0}/var.txt".format(outputdir))


def generate_constraints(projectdir, outputdir, global_constant_C):
    print("Building constraints...")
    os.makedirs(outputdir, exist_ok=True)
    delete_old_constraints(outputdir)
    constraints = []
    variables = dict()
    sanit_sink = dict()
    source_sanit = dict()
    source_sink = dict()

    events = readEvents('data/{0}/{0}-eventToReps.prop.csv'.format(projectdir))
    flows = readFlows('data/{0}/{0}-triple.prop.csv'.format(projectdir), events)

    # collecting events for every pair of source/sink/sanitizer
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

    print("Sanitizer-Sink flows: %d" % len(sanit_sink))
    print("Source-Sanitizer flows: %d" % len(source_sanit))
    print("Source-Sink flows: %d" % len(source_sink))

    # collecting all unique representations
    unique_reps=[]
    for e in events.keys():
        for rep in events[e].reps:
            unique_reps.append(rep)

    unique_reps=list(set(unique_reps))
    print("Unique reps: ", len(unique_reps))

    with open("{0}/repToID.txt".format(outputdir), "w") as repToIDfile:
        for i, rep in enumerate(unique_reps):
            variables["n{0}_src".format(i)] = Variable("n{0}_src".format(i))
            variables["n{0}_san".format(i)] = Variable("n{0}_san".format(i))
            variables["n{0}_snk".format(i)] = Variable("n{0}_snk".format(i))
            repToIDfile.write("{0}:n{1}\n".format(rep, i))

    with open("{0}/eventToRepIDs.txt".format(outputdir), "w") as eventToRepIDs:
        for e in events.keys():
            repIDs=["n{0}".format(unique_reps.index(rep)) for rep in events[e].reps]
            eventToRepIDs.write("{0}:{1}\n".format(e, ",".join(repIDs)))

    # constraints for known sources
    print("Constraints for known events")
    known_sources=readKnown("data/{0}/{0}-src.prop.csv".format(projectdir))
    known_sinks=readKnown("data/{0}/{0}-sinks.prop.csv".format(projectdir))
    known_sanitizers=readKnown("data/{0}/{0}-sanitizers.prop.csv".format(projectdir))

    candidate_sources = readURL("data/{0}/{0}-srcToRep.prop.csv".format(projectdir))
    candidate_sinks = readURL("data/{0}/{0}-snkToRep.prop.csv".format(projectdir))
    candidate_sanitizers = readURL("data/{0}/{0}-sanToRep.prop.csv".format(projectdir))

    # classes_sources=readClass("data/{0}/wclass/{0}-src.prop.csv".format(projectdir))
    # classes_sinks=readClass("data/{0}/wclass/{0}-sinks.prop.csv".format(projectdir))
    # classes_sanitizers=readClass("data/{0}/wclass/{0}-sanitizers.prop.csv".format(projectdir))

    # known_sources=list(filter(lambda x: 'DomBasedXss' not in classes_sources[x], known_sources))
    # known_sinks=list(filter(lambda x: 'DomBasedXss' not in classes_sinks[x], known_sinks))
    # known_sanitizers=list(filter(lambda x: 'DomBasedXss' not in classes_sanitizers[x], known_sanitizers))

    blacklist=createBlackList(events, known_sources, known_sinks)
    print("Events in blacklist: {0}".format(len(blacklist)))

    set_sources=0
    for src in known_sources:
        if src not in events.keys() or src not in candidate_sources or src in blacklist:
            continue
        printKnownConstraints(outputdir, events[src], {"src": "1"}, unique_reps)
        set_sources += 1
        for rep in events[src].reps:
            if rep not in unique_reps:
                continue

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
        if sink not in events.keys() or sink not in candidate_sinks or sink in blacklist:
            continue
        printKnownConstraints(outputdir, events[sink], {"snk": "1"}, unique_reps)
        set_sinks += 1
        for rep in events[sink].reps:
            if rep not in unique_reps:
                continue

            srcVar = getVar(unique_reps, rep, "src")
            sanVar = getVar(unique_reps, rep, "san")
            snkVar = getVar(unique_reps, rep, "snk")
            # if variables[snkVar].is_constant:
            #     print("{0} already constant".format(snkVar))
            variables[srcVar].set_constant(0.0)
            variables[sanVar].set_constant(0.0)
            variables[snkVar].set_constant(1.0)


    set_san=0
    for san in known_sanitizers:
        if san not in events.keys() or san not in candidate_sanitizers:
            continue
        printKnownConstraints(outputdir, events[san], {"san": "1"}, unique_reps)
        set_san += 1
        for rep in events[san].reps:
            if rep not in unique_reps:
                continue

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

    # add constraints for candidate src/sink/san
    print("Adding constraints for candidates")
    with open("{0}/constraints_candidate.txt".format(outputdir), "w") as candidatesfile:
        flowevents = []
        for f in flows:
            flowevents.append(f.source)
            flowevents.append(f.sink)
            flowevents.append(f.sanitizer)
        flowevents = set(flowevents)

        for event in flowevents:
            e=event.id
            if e in known_sources or e in known_sinks or e in known_sanitizers:
                continue
            if e not in candidate_sources:
                candidatesfile.write(Constraint.print(getBackOffVar(unique_reps, event, "src"), "0", Constraint.Constraint.LTE))
                candidatesfile.write("\n")
            if e not in candidate_sinks:
                candidatesfile.write(
                    Constraint.print(getBackOffVar(unique_reps, event, "snk"), "0", Constraint.Constraint.LTE))
                candidatesfile.write("\n")
            if e not in candidate_sanitizers:
                candidatesfile.write(
                    Constraint.print(getBackOffVar(unique_reps, event, "san"), "0", Constraint.Constraint.LTE))
                candidatesfile.write("\n")


if __name__ == '__main__':
    config = SolverConfig()
    # projectdir='eclipse_orion'
    projectdir = config.projectdir
    outputdir = config.constraints_output_dir
    global_constant_C = config.constraints_constant_C
    generate_constraints(projectdir, outputdir, global_constant_C)