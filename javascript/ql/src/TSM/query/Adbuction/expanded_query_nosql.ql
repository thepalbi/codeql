/**
 * @name Expanded query por nosql
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/expanded-query
*/

import config_expanded_nosql
import DataFlow::PathGraph
//import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import evaluation.NosqlInjectionWorse
import semmle.javascript.security.dataflow.NosqlInjection
import TSM.PropagationGraphs


query predicate compareAlertsCount(int vWorse, int v0, int vExpanded) {
  vExpanded = count(DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(ExpandedConfiguration::ExpandedConfiguration cfg | cfg.hasFlowPath(source, sink))
  )
  and 
  vWorse = count(DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(NosqlInjectionWorse::Configuration cfg | cfg.hasFlowPath(source, sink))
  )
  and
  v0 = count(DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(NosqlInjection::Configuration cfg | cfg.hasFlowPath(source, sink))
  )

}


predicate sameLocationInfo(DataFlow::PathNode n1,DataFlow::PathNode n2) {
  exists(string filepath, int startline, int startcolumn, 
          int endline, int endcolumn | 
         n1.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
     and n2.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  )
}

query predicate compareV0vsExpanded(int new, int missing, int same) {
  new = count(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(ExpandedConfiguration::ExpandedConfiguration cfg| 
             cfg.hasFlowPath(source, sink)
             and not exists(NosqlInjection::Configuration cfgV0,
                  DataFlow::PathNode source2, DataFlow::PathNode sink2 |
                cfgV0.hasFlowPath(source2, sink2)
                and sameLocationInfo(source, source2)
                and sameLocationInfo(sink, sink2)
              )
      )
     )
  and 
  missing = count(
    DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(NosqlInjection::Configuration cfgV0| 
           cfgV0.hasFlowPath(source, sink)
           and not exists(ExpandedConfiguration::ExpandedConfiguration cfg,
                DataFlow::PathNode source2, DataFlow::PathNode sink2 |
              cfg.hasFlowPath(source2, sink2)
              and sameLocationInfo(source, source2)
              and sameLocationInfo(sink, sink2)
            )
    )
   )
   and
   same = count(
    DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(ExpandedConfiguration::ExpandedConfiguration cfg| 
           cfg.hasFlowPath(source, sink)
           and exists(NosqlInjection::Configuration cfgV0,
                DataFlow::PathNode source2, DataFlow::PathNode sink2 |
              cfgV0.hasFlowPath(source2, sink2)
              and sameLocationInfo(source, source2)
              and sameLocationInfo(sink, sink2)
            )
    )
   )


}

predicate sinksToBlame(DataFlow::PathNode sink, int repetitions) {
  repetitions = count(
      DataFlow::PathNode source |
      exists(ExpandedConfiguration::ExpandedConfiguration cfg| 
             cfg.hasFlowPath(source, sink)
             and not exists(NosqlInjection::Configuration cfgV0,
                  DataFlow::PathNode source2, DataFlow::PathNode sink2 |
                cfgV0.hasFlowPath(source2, sink2)
                and sameLocationInfo(source, source2)
                and sameLocationInfo(sink, sink2)
              )
      )
     )
    and repetitions>0
}

query predicate sinksToBlameFiltered(DataFlow::PathNode sink, int repetitions, string rep) {
  sinksToBlame(sink, repetitions)   
  and exists( int maxDepth |  maxDepth > 0
        and rep =  candidateRep(sink.getNode(), maxDepth) 
        and maxDepth = max( int d | 
                  exists(DataFlow::PathNode sink2 | 
                      sameLocationInfo(sink, sink2 ) 
                    and exists(string rep2  |   
                      candidateRep(sink.getNode(), d) = rep2 )
                  ) 
        )
    )
}


/***
 * This predicate provides the (src,snk) pairs from the alerts
 * To-do: remove the alerts from V0
 */
query predicate pairSrcSnkAlert(string ssrc, string ssnk){
  exists(PropagationGraph::Node src, PropagationGraph::Node snk, 
    DataFlow::PathNode source, DataFlow::PathNode sink, 
    ExpandedConfiguration::ExpandedConfiguration cfg | 
    cfg.hasFlowPath(source, sink)
    and source.getNode() = src.asDataFlowNode()
    and sink.getNode() = snk.asDataFlowNode() 
    and
    // ssrc = src.getconcatrep() and 
    // ssnk = snk.getconcatrep()    
    ssrc = src.preciseRep(false) and 
    ssnk = snk.preciseRep(true)  
    )
}

// from
//   DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
//   int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
//   int startLineSource, int endLineSource, int startColumnSource, int endColumnSource
// where
//   cfg instanceof ExpandedConfiguration::ExpandedConfiguration and
//   cfg.hasFlow(source, sink) and
//   sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
//   source
//       .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
//         endColumnSource)
// select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
//   sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink

from ExpandedConfiguration::ExpandedConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
//   (
//     cfg instanceof ExpandedConfiguration::ExpandedConfiguration
//   ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
  "a user-provided value"
