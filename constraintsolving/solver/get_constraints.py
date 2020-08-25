from DataParser import readFlows, readEvents, readKnown, readClass, readURL, readFlowsAndReps, readPairs
from Variable import Variable
import Constraint
import os
import re
import shutil
from .config import SolverConfig

class ConstraintBuilder:
    def __init__(self, mode, outputdir, min_rep_events, dataset_type, constraint_format, lambda_const):
        self.events = dict()
        self.unique_reps = dict()
        self.reps_map = dict()
        self.mode = mode
        self.outputdir = outputdir
        os.makedirs(outputdir, exist_ok=True)
        self.delete_old_constraints()
        self.variables = dict()
        self.eps_vars = list()
        self.known_sources = dict()
        self.known_sinks = dict()
        self.known_sanitizers = dict()
        self.rep_count = dict()
        self.min_rep_events = min_rep_events
        self.dataset_type = dataset_type
        self.constraint_format = constraint_format
        self.lambda_const = lambda_const
        self._src = "s"
        self._san = "a"
        self._snk = "i"
        self._eps = "e"

    def set_output_dir(self, newdir):
        self.outputdir = newdir


    def readEventsAndReps(self, projectdir):
        readEvents('data/{0}/{0}-eventToConcatRep{1}.prop.csv'.format(projectdir,
                                                                      "-" + self.dataset_type if
                                                                      self.dataset_type is not None else ""),
                   self.events,
                   self.unique_reps,
                   self.rep_count)

    def createBlackList(self):
        blacklist = []
        for k in self.known_sources.keys():
            for src in self.known_sources[k]:
                if src not in self.events.keys():
                    continue
                src_reps = set(self.events[src].reps)

                for k2 in self.known_sinks.keys():
                    for snk in self.known_sinks[k2]:
                        if snk not in self.events.keys():
                            continue
                        snk_reps = set(self.events[snk].reps)
                        if len(src_reps.intersection(snk_reps)) > 0:
                            blacklist.append(src)
                            blacklist.append(snk)

                for k3 in self.known_sanitizers.keys():
                    for san in self.known_sanitizers[k3]:
                        if san not in self.events.keys():
                            continue
                        san_reps = set(self.events[san].reps)
                        if len(src_reps.intersection(san_reps)) > 0:
                            blacklist.append(src)
                            blacklist.append(san)

        for k in self.known_sinks.keys():
            for snk in self.known_sinks[k]:
                if snk not in self.events.keys():
                    continue
                snk_reps = set(self.events[snk].reps)
                for k2 in self.known_sanitizers.keys():
                    for san in self.known_sanitizers[k2]:
                        if san not in self.events.keys():
                            continue
                        san_reps = set(self.events[san].reps)
                        if len(snk_reps.intersection(san_reps)) > 0:
                            blacklist.append(snk)
                            blacklist.append(san)
        return list(set(blacklist))

    def createBlackList2(self, sources, sinks, sanitizers):
        # ignoring sanitizers for now
        blacklist=[]
        for source in sources:
            if source not in self.events.keys():
                continue
            source_reps = set(self.events[source].reps)
            for sink in sinks:
                if sink not in self.events.keys():
                    continue
                sink_reps = set(self.events[sink].reps)
                if len(source_reps.intersection(sink_reps)) > 0:
                    blacklist.append(source)
                    blacklist.append(sink)
            for san in sanitizers:
                if san not in self.events.keys():
                    continue
                san_reps = set(self.events[san].reps)
                if len(source_reps.intersection(san_reps)) > 0:
                    blacklist.append(source)
                    blacklist.append(san)

        for sink in sinks:
            if sink not in self.events.keys():
                continue
            sink_reps = set(self.events[sink].reps)
            for san in sanitizers:
                if san not in self.events.keys():
                    continue

                san_reps = set(self.events[san].reps)
                if len(sink_reps.intersection(san_reps)) > 0:
                    blacklist.append(sink)
                    blacklist.append(san)

        return list(set(blacklist))

    def getVar(self, rep, suffix=""):
        # if self.rep_count[rep] >= self.min_rep_events:
        return "n{0}{1}".format(self.unique_reps[rep], suffix)
        # else:
        #     assert False, "Invalid rep"

    def getBackOffVar(self, event, suffix, constraint_type="flow"):
        reps = event.reps
        #reps = list(filter(lambda x: self.rep_count[x] >= self.min_rep_events, reps))
        if len(reps) == 0:
            assert False, "No Reps"
        elif len(reps) > 1:
            if self.constraint_format == "gb":
                if constraint_type == "known":
                    return " + ".join([self.getVar(r, suffix) for r in reps]), len(reps)
                else:
                    factor = "{0:.2f}".format(1.0/len(reps))
                    return " + ".join([factor + " " + self.getVar(r, suffix) for r in reps])
            else:
                return "({0})/{1}".format("+".join([self.getVar(r, suffix) for r in reps]), len(reps))
        else:
            if constraint_type == "flow":
                return "{0}".format(" + ".join([self.getVar(r, suffix) for r in reps]))
            else:
                return "{0}".format(" + ".join([self.getVar(r, suffix) for r in reps])), 1

    def printKnownConstraints(self,  event, map:dict):
        with open("{0}/constraints_known_{1}.txt".format(self.outputdir, list(map.keys())[0]), "a+") as constraintsfile:
            src_var, src_rhs = self.getBackOffVar(event, self._src, "known")
            constraintsfile.write(
                Constraint.print(src_var,
                                 src_rhs if "src" in map else "0", Constraint.Constraint.LTE, format='norm'))
            constraintsfile.write(",")
            constraintsfile.write(
                Constraint.print(src_var,
                                 src_rhs if "src" in map else "0", Constraint.Constraint.GTE, format='norm'))
            constraintsfile.write(",")


            san_var, san_rhs = self.getBackOffVar(event, self._san, "known")
            constraintsfile.write(
                Constraint.print(san_var,
                                 str(san_rhs) if "san" in map else "0", Constraint.Constraint.LTE, format='norm'))
            constraintsfile.write(",")
            constraintsfile.write(
                Constraint.print(san_var,
                                 str(san_rhs) if "san" in map else "0", Constraint.Constraint.GTE, format='norm'))
            constraintsfile.write(",")

            snk_var, snk_rhs = self.getBackOffVar(event, self._snk, "known")
            constraintsfile.write(
                Constraint.print(snk_var,
                                 str(snk_rhs) if "snk" in map else "0", Constraint.Constraint.LTE, format='norm'))
            constraintsfile.write(",")
            constraintsfile.write(
                Constraint.print(snk_var,
                                 str(snk_rhs) if "snk" in map else "0", Constraint.Constraint.GTE, format='norm'))
            constraintsfile.write("\n")


    def delifexists(self, f):
        if os.path.exists(f):
            os.remove(f)

    def delete_old_constraints(self):
        self.delifexists("{0}/constraints_var.txt".format(self.outputdir))
        self.delifexists("{0}/constraints_flow.txt".format(self.outputdir))
        self.delifexists("{0}/constraints_known.txt".format(self.outputdir))
        self.delifexists("{0}/constraints_known_src.txt".format(self.outputdir))
        self.delifexists("{0}/constraints_known_san.txt".format(self.outputdir))
        self.delifexists("{0}/constraints_known_snk.txt".format(self.outputdir))
        self.delifexists("{0}/var.txt".format(self.outputdir))

    def createVariables(self):
        print("Creating variables")

        with open("{0}/repToID.txt".format(self.outputdir), "w") as repToIDfile:
            newvars=[["n{0}{1}".format(self.unique_reps[k], self._src),
                      "n{0}{1}".format(self.unique_reps[k], self._san),
                      "n{0}{1}".format(self.unique_reps[k], self._snk)]
                     for k in self.unique_reps.keys()]
            print("Built vars")
            for k in newvars:
                self.variables[k[0]] = Variable(k[0])
                self.variables[k[1]] = Variable(k[1])
                self.variables[k[2]] = Variable(k[2])
            # for _, (rep,i) in enumerate(self.unique_reps.items()):
            #     self.variables["n{0}_src".format(i)] = Variable("n{0}_src".format(i))
            #     self.variables["n{0}_san".format(i)] = Variable("n{0}_san".format(i))
            #     self.variables["n{0}_snk".format(i)] = Variable("n{0}_snk".format(i))
                #outputstring += "{0}:n{1}\n".format(rep, i)
            print("Done variables")

            repToIDfile.write("\n".join(["{0}:n{1}".format(k, self.unique_reps[k]) for k in self.unique_reps.keys()]))

            print("Wrote to file")
        with open("{0}/eventToRepIDs.txt".format(self.outputdir), "w") as eventToRepIDs:
            for e in self.events.keys():
                repIDs = ["n{0}".format(self.unique_reps[rep]) for rep in self.events[e].reps]
                eventToRepIDs.write("{0}:{1}\n".format(e, ",".join(repIDs)))

    def readAllKnown(self, projectdir, query, query_type, use_all_sanitizers):
        # constraints for known sources
        print("Constraints for known events")
        known_sources = readKnown("data/{0}/{0}-{1}-{2}.prop.csv".format(projectdir, "sources", query_type), "sources", query)
        known_sinks = readKnown("data/{0}/{0}-{1}-{2}.prop.csv".format(projectdir,"sinks",query_type), "sinks", query)
        if use_all_sanitizers:
            print("Using all sanitizers")
            # TO-DO: Check last parameter: Is None or should be removed?
            known_sanitizers = readKnown("data/{0}/{0}-{1}-{2}.prop.csv".format(projectdir, "sanitizers", query_type), "sanitizers", None)
        else:
            known_sanitizers = readKnown("data/{0}/{0}-{1}-{2}.prop.csv".format(projectdir, "sanitizers", query_type), "sanitizers", query)
        self.known_sources[projectdir] = known_sources
        self.known_sinks[projectdir] = known_sinks
        self.known_sanitizers[projectdir] = known_sanitizers

    def writeKnownConstraints(self):
        print("Computing blacklist")
        blacklist = self.createBlackList()

        if len(blacklist) > 0:
            print(blacklist)
            print("Events in blacklist: {0}".format(len(blacklist)))

        set_sources = 0
        for k in self.known_sources:
            for src in self.known_sources[k]:
                if src not in self.events.keys() or src in blacklist:
                    continue
                self.printKnownConstraints(self.events[src], {"src": "1"})
                set_sources += 1
                for rep in self.events[src].reps:
                    if rep not in self.unique_reps:
                        continue
                    srcVar = self.getVar(rep, self._src)
                    sanVar = self.getVar(rep, self._san)
                    snkVar = self.getVar(rep, self._snk)
                    self.variables[srcVar].set_constant(1.0)
                    self.variables[sanVar].set_constant(0.0)
                    self.variables[snkVar].set_constant(0.0)

        set_sinks = 0
        for k in self.known_sinks:
            for sink in self.known_sinks[k]:
                if sink not in self.events.keys() or sink in blacklist:
                    continue
                self.printKnownConstraints(self.events[sink], {"snk": "1"})
                set_sinks += 1
                for rep in self.events[sink].reps:
                    if rep not in self.unique_reps:
                        continue

                    srcVar = self.getVar(rep, self._src)
                    sanVar = self.getVar(rep, self._san)
                    snkVar = self.getVar(rep, self._snk)
                    # if variables[snkVar].is_constant:
                    #     print("{0} already constant".format(snkVar))
                    self.variables[srcVar].set_constant(0.0)
                    self.variables[sanVar].set_constant(0.0)
                    self.variables[snkVar].set_constant(1.0)

        set_san = 0
        for k in self.known_sanitizers:
            for san in self.known_sanitizers[k]:
                if san not in self.events.keys() or san in blacklist:
                    continue
                self.printKnownConstraints(self.events[san], {"san": "1"})
                set_san += 1
                for rep in self.events[san].reps:
                    if rep not in self.unique_reps:
                        continue

                    srcVar = self.getVar(rep, self._src)
                    sanVar = self.getVar(rep, self._san)
                    snkVar = self.getVar(rep, self._snk)
                    # if variables[sanVar].is_constant:
                    #     print("{0} already constant".format(sanVar))
                    self.variables[srcVar].set_constant(0.0)
                    self.variables[sanVar].set_constant(1.0)
                    self.variables[snkVar].set_constant(0.0)

        print("Known sources: %d" % set_sources, end=',')
        print("Known sanitizers: %d" % set_san, end=',')
        print("Known sinks: %d" % set_sinks)

    def writeVarConstrants(self):
        # output var.txt and constraints_var.txt
        with open("{0}/var.txt".format(self.outputdir), "w") as varfile:
            varfile.write("\n".join([self.variables[v].print() for v in self.variables.keys()]))
            varfile.write("\n")
            # for v in self.variables.keys():
            #     varfile.write(self.variables[v].print())
            #     varfile.write("\n")

        with open("{0}/var.txt".format(self.outputdir), "a") as varfile:
            varfile.write("\n".join([v+":variable" for v in self.eps_vars]))
            varfile.write("\n")
            # for v in self.eps_vars:
            #     varfile.write(v + ":variable")
            #     varfile.write("\n")

        # output constraints.txt
        with open("{0}/constraints_var.txt".format(self.outputdir), "a+") as constraintsfile:
            constraintsfile.write("\n".join([Constraint.print(self.variables[v].id, "1", Constraint.Constraint.LTE, format='norm')
                                             for v in self.variables.keys() if not self.variables[v].is_constant]))
            constraintsfile.write("\n")
            constraintsfile.write("\n".join([Constraint.print(self.variables[v].id, "0", Constraint.Constraint.GTE, format='norm')
                                             for v in self.variables.keys() if not self.variables[v].is_constant]))
            constraintsfile.write("\n")
            # for v in self.variables.keys():
            #     if not self.variables[v].is_constant:
            #         constraintsfile.write(Constraint.print(self.variables[v].id, "1", Constraint.Constraint.LTE))
            #         constraintsfile.write("\n")
            #         constraintsfile.write(Constraint.print(self.variables[v].id, "0", Constraint.Constraint.GTE))
            #         constraintsfile.write("\n")

        with open("{0}/constraints_var.txt".format(self.outputdir), "a") as constraintsfile:
            constraintsfile.write("\n".join([Constraint.print(v, "0", Constraint.Constraint.GTE, format='norm') for v in self.eps_vars]))
            constraintsfile.write("\n")
            # for v in self.eps_vars:
            #     constraintsfile.write(Constraint.print(v, "0", Constraint.Constraint.GTE))
            #     constraintsfile.write("\n")

    def ff(self, row, events, flow_list, other):
        sinks = list(other[other["ssan"] == row["ssan"]]["ssnk"])
        pass

    def generate_flow_constraints_join(self, projectdir, global_constant_C):
        src_san_pairs = readPairs('data/{0}/{0}-pairSrcSan-{1}.prop.csv'.format(projectdir,  "-" + self.dataset_type if
                                                                      self.dataset_type is not None else ""), self.events)
        san_snk_pairs = readPairs('data/{0}/{0}-pairSrcSan-{1}.prop.csv'.format(projectdir,  "-" + self.dataset_type if
                                                                      self.dataset_type is not None else ""), self.events)

        #triples = src_san_pairs.join(san_snk_pairs, on="ssan", how='inner')
        flow_list = []
        src_san_pairs.apply(lambda x: self.ff(x, self.events, flow_list, san_snk_pairs))


        pass

    def generate_flow_constraints(self, projectdir, global_constant_C, query=None):
        sanit_sink = dict()
        source_sanit = dict()
        source_sink = dict()

        flows = readFlowsAndReps('data/{0}/{0}-triple-id{1}.prop.csv'.format(projectdir,  "-" + self.dataset_type if
                                                                      self.dataset_type is not None else ""), self.events)

        print("Unique reps: ", len(self.unique_reps))

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

        print("Flows: San-Snk {0}, Src-San {1}, Src-Snk {2}".format(len(sanit_sink), len(source_sanit), len(source_sink)))

        with open("{0}/constraints_flow.txt".format(self.outputdir), "a+") as constraintsfile:
            # constraintsfile.write("\n".join(
            #     Constraint.print("{0} + {1}".format(self.getBackOffVar(k[0], "san"),
            #                                         self.getBackOffVar(k[1], "snk")),
            #                      "{0} + {1} + {2}".format(" + ".join([self.getBackOffVar(k, "src")
            #                                                           for k in sanit_sink[k]]),
            #                                               global_constant_C,
            #                                               "eps_{0}".format(len(self.eps_vars)+i)),
            #                      Constraint.Constraint.LTE) for i,k in enumerate(sanit_sink.keys())
            # ))

            for ss in sanit_sink.keys():
                newepsvar = "{0}{1}".format(self._eps, len(self.eps_vars))
                self.eps_vars.append(newepsvar)
                # get rep for each node
                # constraintsfile.write(Constraint.print("{0} + {1}".format(self.getBackOffVar(ss[0], "san"),
                #                                                           self.getBackOffVar(ss[1], "snk")),
                #                                        "{0} + {1} + {2}".format(" + ".join([self.getBackOffVar(k, "src")
                #                                                                             for k in sanit_sink[ss]]),
                #                                                                 global_constant_C,
                #                                                                 newepsvar),
                #                                        Constraint.Constraint.LTE))
                constraintsfile.write(Constraint.print("{0} + {1} - {2} - {3}".format(self.getBackOffVar(ss[0], self._san),
                                                                          self.getBackOffVar(ss[1], self._snk),
                                                                                      " + ".join(
                                                                                          [self.getBackOffVar(k, self._src)
                                                                                           for k in sanit_sink[ss]]).replace(" + ", " - "),
                                                                                      newepsvar
                                                                                      ),
                                                       "{0}".format(global_constant_C),
                                                       Constraint.Constraint.LTE, format='norm'))
                constraintsfile.write("\n")

            for ss in source_sanit.keys():
                newepsvar = "{0}{1}".format(self._eps, len(self.eps_vars))
                self.eps_vars.append(newepsvar)
                # constraintsfile.write(Constraint.print(
                #     "{0} + {1}".format(self.getBackOffVar(ss[0], "src"), self.getBackOffVar(ss[1], "san")),
                #     "{0} + {1} + {2}".format(" + ".join([self.getBackOffVar(k, "snk") for k in source_sanit[ss]]),
                #                              global_constant_C, newepsvar), Constraint.Constraint.LTE))
                constraintsfile.write(Constraint.print(
                    "{0} + {1} - {2} - {3}".format(self.getBackOffVar(ss[0], self._src), self.getBackOffVar(ss[1], self._san)
                                                   , " + ".join([self.getBackOffVar(k, self._snk) for k in source_sanit[ss]]).replace(" + ", " - "),
                                                   newepsvar
                                                   ),
                    "{0}".format(global_constant_C), Constraint.Constraint.LTE, format='norm'))

                constraintsfile.write("\n")

            for ss in source_sink.keys():
                newepsvar = "{0}{1}".format(self._eps, len(self.eps_vars))
                self.eps_vars.append(newepsvar)
                # constraintsfile.write(Constraint.print(
                #     "{0} + {1}".format(self.getBackOffVar(ss[0], "src"), self.getBackOffVar(ss[1], "snk")),
                #     "{0} + {1} + {2}".format(" + ".join([self.getBackOffVar(k, "san") for k in source_sink[ss]]),
                #                              global_constant_C, newepsvar), Constraint.Constraint.LTE))
                constraintsfile.write(Constraint.print(
                    "{0} + {1} - {2} - {3}".format(self.getBackOffVar(ss[0], self._src),
                                                   self.getBackOffVar(ss[1], self._snk),
                                                   " + ".join([self.getBackOffVar(k, self._san) for k in source_sink[ss]]).replace(" + ", " - "),
                                                   newepsvar
                                                   ),
                    "{0}".format(global_constant_C), Constraint.Constraint.LTE, format='norm'))
                constraintsfile.write("\n")

    def removeRareEvents(self):
        keys=list(self.events.keys())
        dropped=0
        for k in keys:
            reps = list(filter(lambda x: self.rep_count[x] >= self.min_rep_events, self.events[k].reps))
            if len(reps) == 0:
                self.events.pop(k)
                dropped+=1

        print("Dropped: %d" % dropped)

    def writeObjective(self):
        with open("{0}/objective.txt".format(self.outputdir), "w") as objectivefile:
            obj = " + ".join(["{0} ".format(self.lambda_const) + k for k in self.variables.keys()])
            obj = obj + " + " + " + ".join(self.eps_vars)
            objectivefile.write(obj)
            objectivefile.write("\n")


