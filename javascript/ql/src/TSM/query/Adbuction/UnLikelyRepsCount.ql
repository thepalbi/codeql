/**
 * @name General TSM query
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/tsm-query
*/

import DataFlow::PathGraph
import TSM.PropagationGraphs
import unlikelyReps

predicate sameLocationInfo(DataFlow::PathNode n1,DataFlow::PathNode n2) {
  exists(string filepath, int startline, int startcolumn, 
          int endline, int endcolumn | 
         n1.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
     and n2.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  )
}

query predicate countRep(string rep, int repetitions) {
  UnlikelyReps::getRep(rep, "snk") and
  repetitions = count(
    DataFlow::Node sink | rep =  candidateRep(sink, _, true)
  )
  and repetitions>0
}

// from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
// where
//   (
//     cfg instanceof BoostedConfigFilter::BoostedConfigFilterV0
//   ) and
//   cfg.hasFlowPath(source, sink)
// select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
//   "a user-provided value"
