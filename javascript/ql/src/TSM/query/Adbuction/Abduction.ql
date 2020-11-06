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
import semmle.javascript.security.dataflow.TaintedPath::TaintedPath
import config_expanded
import boosted_config


predicate isV0(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(Configuration cfg | 
    cfg.hasFlowPath(source, sink)
  )
}

predicate isExpanded(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(ExpandedConfiguration::ExpandedConfiguration cfg |
      cfg.hasFlowPath(source, sink)
  )
}

predicate isBoosted(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(BoostedConfig::Configuration cfg | 
    cfg.hasFlowPath(source, sink)
  )
}

/**
 * v0 the original number of alerts
 * vBoosted the additional number of alerts 
 * vExpandad the potencial number of alerts
 */
query predicate compareAlertsCount(int vBoosted, int vExpanded, int v0) {
  v0 = count(DataFlow::PathNode source, DataFlow::PathNode sink |    
                         isV0(source, sink))
  and 
  vBoosted = count(DataFlow::PathNode source, DataFlow::PathNode sink |
                  isBoosted(source, sink) ) - v0
  and 
  vExpanded = count(DataFlow::PathNode source, DataFlow::PathNode sink |
                      isExpanded(source, sink)) - v0
}

