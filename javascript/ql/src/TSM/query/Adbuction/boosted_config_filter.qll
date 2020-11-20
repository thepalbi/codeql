/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import TSM.NodeRepresentation
import tsm_repr_pred_nosql
import semmle.javascript.security.TaintedObject
import config_expanded_nosql
import backlist

private float minScore_snk() { result = 0.00001}
private float minScore_src() { result = 0.0001}
// Score>1 to ignore sanitizers
private float minScore_san() { result = 1.1}


module BoostedConfigFilter {
  private import TsmRepr
  private import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
  private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations

  string rep(DataFlow::Node node){
      result = candidateRep(node, _)
  }

  string repSink(DataFlow::Node node){
    result = candidateRep(node, _, true)
}

  predicate testSink2(DataFlow::Node node, string repr) 
  {
      repr = rep(node) 
      and repr.indexOf("/mv") >0
  }

  predicate testSink(DataFlow::Node node, string repr) 
  {
    exists (float score  |
        repr = rep(node)  and   score = max(TSM::doGetReprScore(repr, "snk"))
        and score > 0
    )
  }
  module TSM {
    predicate isSink(DataFlow::Node node, float score){
      // (exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "snk"))/count(rep(node)) or
      (exists(rep(node)) and   score = max(doGetReprScore(rep(node), "snk")) or
        not exists(rep(node)) and score = 0)
    }

    predicate isSource(DataFlow::Node node, float score){
      // (exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "src"))/count(rep(node)) or 
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
  }

  predicate blackListedSource(DataFlow::Node sink) {
    exists (string rep |  
      BlackList::getRep(rep, "src") and
      rep =  candidateRep(sink, _, false)
    )    
  }

  predicate blackListedSink(DataFlow::Node sink) {
    exists (string rep |  
      BlackList::getRep(rep, "snk") and
      rep =  candidateRep(sink, _, true)
    )    
  }
  /**
   * This is the boosting of version VWorse using sink candidates 
   * and precluding reps from a black list
   */
 class BoostedConfigFilter extends ExpandedConfiguration::ExpandedConfiguration { // TaintTracking::Configuration {
  BoostedConfigFilter() {  this = "BoostedConfigFilter" }

  // override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
  //   not exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
  //   and 
  //   super.isSource(source, label)
  // }

  // override predicate isSource(DataFlow::Node source) { 
  //   not exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
  //   and
  //   super.isSource(source)
  //   // or source instanceof NosqlInjectionWorse::Source
  // }
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    (super.isSink(sink, label) 
      and not blackListedSink(sink)
    )    
    //not exists (float score | TSM::isSink(sink, score) and score>=minScore_snk())
    or sink.(NosqlInjectionWorse::Sink).getAFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    // exists (float score | TSM::isSanitizer(node, score) and score>=minScore_san()) 
    // or
    // node instanceof NosqlInjectionWorse::Sanitizer
  }
}

/**
 * This is the V0 version boosted with new new candidates
 * and precluding reps from a black list
 */
class BoostedConfigFilterV0 extends TaintTracking::Configuration {
  BoostedConfigFilterV0() { this = "BoostedConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof NosqlInjection::Source 
  }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    (ExpandedConfiguration::isCandidateSink(sink)
      and not blackListedSink(sink)
    )    
    //not exists (float score | TSM::isSink(sink, score) and score>=minScore_snk())
    or 
    sink.(NosqlInjection::Sink).getAFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof NosqlInjection::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // additional flow step to track taint through NoSQL query objects
    inlbl = TaintedObject::label() and
    outlbl = TaintedObject::label() and
    exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsToExpr(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
  }
  }
  /**
 * This is the VWorse version boosted with  new candidates
 * and precluding reps from a black list
 */
class BoostedConfigFilterWorse extends TaintTracking::Configuration {
  BoostedConfigFilterWorse() { this = "BoostedConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof NosqlInjectionWorse::Source 
  }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    (ExpandedConfiguration::isCandidateSink(sink)
    and not blackListedSink(sink)
    )
    or 
    sink.(NosqlInjectionWorse::Sink).getAFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof NosqlInjectionWorse::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // additional flow step to track taint through NoSQL query objects
    inlbl = TaintedObject::label() and
    outlbl = TaintedObject::label() and
    exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsToExpr(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
  }
  }
}
