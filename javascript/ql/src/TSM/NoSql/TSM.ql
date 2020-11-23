/**
 * @name General TSM query
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/tsm-query
*/

import tsm_config
import DataFlow::PathGraph
//import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.NosqlInjection

predicate sameLocationInfo(DataFlow::PathNode n1,DataFlow::PathNode n2) {
  exists(string filepath, int startline, int startcolumn, 
          int endline, int endcolumn | 
         n1.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
     and n2.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  )
}

query predicate compareV0vsWorseBoosted(int new, int missing, int same) {
  new = count(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(TSMConfig::Configuration cfg| 
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
           and not exists(TSMConfig::Configuration cfg,
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
    exists(TSMConfig::Configuration cfg| 
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


from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  (
    cfg instanceof TSMConfig::Configuration
  ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
  "a user-provided value"
