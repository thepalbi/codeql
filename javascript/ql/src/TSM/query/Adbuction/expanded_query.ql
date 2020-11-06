/**
 * @name General TSM query
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/expanded-query
*/

import config_expanded
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.TaintedPath::TaintedPath
import TSM.PropagationGraphs


query predicate compareAlertsCount(int v0, int vExpanded) {
  vExpanded = count(DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(ExpandedConfiguration::ExpandedConfiguration cfg | cfg.hasFlowPath(source, sink))
  )
  and 
  v0 = count(DataFlow::PathNode source, DataFlow::PathNode sink |
    exists(Configuration cfg | cfg.hasFlowPath(source, sink))
  )
}

/***
 * This predicate provides the (src,snk) pairs from the alerts
 * To-do: remove the alerts from V0
 */
query predicate pairSrcSnkAlert(string ssrc, string ssnk){
  exists(PropagationGraph::Node src, PropagationGraph::Node snk, 
    DataFlow::PathNode source, DataFlow::PathNode sink, 
    ExpandedConfiguration::ExpandedConfiguration cfg | cfg.hasFlowPath(source, sink)
    and source.getNode() = src.asDataFlowNode()
    and sink.getNode() = snk.asDataFlowNode() 
    and
    ssrc = src.getconcatrep() and 
    ssnk = snk.getconcatrep()    
    )
}

from
  DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource
where
  cfg instanceof ExpandedConfiguration::ExpandedConfiguration and
  cfg.hasFlow(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource)
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink

// from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
// where
//   (
//     cfg instanceof ExpandedConfiguration::ExpandedConfiguration
//   ) and
//   cfg.hasFlowPath(source, sink)
// select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
//   "a user-provided value"
