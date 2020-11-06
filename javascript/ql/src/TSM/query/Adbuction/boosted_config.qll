/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
//import semmle.javascript.security.dataflow.TaintedPathCustomizations
import TSM.NodeRepresentation
import tsm_repr_pred

private float minScore_snk() { result = 0.1}
private float minScore_src() { result = 0.1}
// Score>1 to ignore sanitizers
private float minScore_san() { result = 1.1}


module BoostedConfig {
  private import TsmRepr
  private import config_expanded
  private import semmle.javascript.security.dataflow.TaintedPath

  string rep(DataFlow::Node node){
      result = candidateRep(node, _)
  }

  predicate testSink2(DataFlow::Node node, string repr) 
  {
      repr = rep(node) 
      and repr.indexOf("/mv") >0
  }

  predicate testSink(DataFlow::Node node, string repr) 
  {
    exists (float score  |
        repr = rep(node)  and   score = max(doGetReprScore(repr, "snk"))
        and score > 0
    )
  }

  predicate isSink(DataFlow::Node node, float score){
      (exists(rep(node)) and   score = max(doGetReprScore(rep(node), "snk")) or
      not exists(rep(node)) and score = 0)
  }

  predicate isSource(DataFlow::Node node, float score){
      (exists(rep(node)) and   score = max(doGetReprScore(rep(node), "src")) or
      not exists(rep(node)) and score = 0)
  }

  predicate isSanitizer(DataFlow::Node node, float score){
      (exists(rep(node)) and
      score = max(doGetReprScore(rep(node), "san")) or
      not exists(rep(node)) and score = 0)
  }

  float doGetReprScore(string repr, string t){
      result = TsmRepr::getReprScore(repr, t)
 }    

  class Configuration extends DataFlow::Configuration { 
    // A tainted path config
    TaintedPath::Configuration config; 

    Configuration() { this = "BostedConfiguration" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      exists (float score |  BoostedConfig::isSource(source, score) and score>=minScore_src()) 
      or config.isSource(source,label)
      //and label = source.(TaintedPath::Source).getAFlowLabel()

    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      exists (float score | BoostedConfig::isSink(sink, score) and score>=minScore_snk()) 
      or config.isSink(sink, label)
      //and label = sink.(TaintedPath::Sink).getAFlowLabel()
    }

    override predicate isBarrier(DataFlow::Node node) {
      config.isBarrier(node)
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      config.isBarrierGuard(guard)
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      config.isAdditionalFlowStep(src, dst, srclabel, dstlabel)
    }
  }


}
