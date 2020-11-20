/**
 * @name General TSM query
 * @description Checking unsanitized flows
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/tsm-query
*/

import boosted_config_filter
import DataFlow::PathGraph
import TSM.PropagationGraphs
import evaluation.NosqlInjectionWorse
import semmle.javascript.security.dataflow.NosqlInjection


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
      exists(BoostedConfigFilter::BoostedConfigFilter cfg| 
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
           and not exists(BoostedConfigFilter::BoostedConfigFilter cfg,
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
    exists(BoostedConfigFilter::BoostedConfigFilter cfg| 
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

query predicate compareV0vsBoosted(int new, int missing, int same) {
  new = count(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(BoostedConfigFilter::BoostedConfigFilterV0 cfg| 
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
           and not exists(BoostedConfigFilter::BoostedConfigFilterV0 cfg,
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
    exists(BoostedConfigFilter::BoostedConfigFilterV0 cfg| 
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

query predicate compareWorsevsBoosted(int new, int missing, int same) {
  new = count(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg| 
             cfg.hasFlowPath(source, sink)
             and not exists(NosqlInjectionWorse::Configuration cfgV0,
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
    exists(NosqlInjectionWorse::Configuration cfgV0| 
           cfgV0.hasFlowPath(source, sink)
           and not exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg,
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
    exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg| 
           cfg.hasFlowPath(source, sink)
           and exists(NosqlInjectionWorse::Configuration cfgV0,
                DataFlow::PathNode source2, DataFlow::PathNode sink2 |
              cfgV0.hasFlowPath(source2, sink2)
              and sameLocationInfo(source, source2)
              and sameLocationInfo(sink, sink2)
            )
    )
   )
}

query predicate compareV0vsWorseBoostedSinks(DataFlow::PathNode sinkNew, string rep) {
  exists(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg| 
             cfg.hasFlowPath(source, sink)
             and not exists(NosqlInjection::Configuration cfgV0,
                  DataFlow::PathNode source2, DataFlow::PathNode sink2 |
                cfgV0.hasFlowPath(source2, sink2)
                and sameLocationInfo(source, source2)
                and sameLocationInfo(sink, sink2)
              )
        and sink = sinkNew
        //and rep = BoostedConfigFilter::repSink(sinkNew.getNode())  
      )
     )
     and rep = depthRep(sinkNew)      
}

string depthRep(DataFlow::PathNode sink) {
  exists( int maxDepth |  maxDepth > 0
        and result  =  candidateRep(sink.getNode(), maxDepth, true) 
        and maxDepth = max( int d | 
                  exists(DataFlow::PathNode sink2 | 
                      sameLocationInfo(sink, sink2 ) 
                    and exists(string rep2  |   
                      candidateRep(sink.getNode(), d, true) = rep2 )
                  ) 
        )
    )
}


query predicate compareV0vsWorseBoosted(int new, int missing, int same) {
  new = count(
      DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg| 
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
           and not exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg,
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
    exists(BoostedConfigFilter::BoostedConfigFilterWorse cfg| 
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
    cfg instanceof BoostedConfigFilter::BoostedConfigFilterV0
  ) and
  cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on $@.", source.getNode(),
  "a user-provided value"
