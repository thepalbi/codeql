/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import semmle.javascript.security.TaintedObject

private float minScore_snk() { result = 0.001}
private float minScore_src() { result = 1.1}
// Score>1 to ignore sanitizers
private float minScore_san() { result = 1.1}

module TSMConfig {
  import tsm
  private import evaluation.TaintedPathCustomizationsWorse

  /**
   * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "TSMConfig" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
      or super.isSource(source, label)
      or  source instanceof TaintedPathWorse::Source 
    }
  
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      exists (float score | TSM::isSink(sink, score) and score>=minScore_snk())
      // or 
      // super.isSink(sink, label)
      or  sink.(TaintedPathWorse::Sink).getAFlowLabel()=label 
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      exists (float score | TSM::isSanitizer(node, score) and score>=minScore_san()) 
      or
      node instanceof TaintedPathWorse::Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof TaintedPathWorse::BarrierGuardNode
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
        TaintedPathWorse::isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
    }
  }

  // /**
  //  * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
  //  */
  // class Configuration2 extends TaintTracking::Configuration {
  //   Configuration2() { this = "TSMConfig" }

  //   override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
  //     exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
  //     or super.isSource(source, label)
  //     or  source instanceof TaintedPathWorse::Source 
  //   }
  
  //   override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
  //     exists (float score | TSM::isSink(sink, score) and score>=minScore_snk())
  //     // or 
  //     // super.isSink(sink, label)
  //     or  sink.(TaintedPathWorse::Sink).getAFlowLabel()=label 
  //   }

  //   override predicate isSanitizer(DataFlow::Node node) {
  //     exists (float score | TSM::isSanitizer(node, score) and score>=minScore_san()) 
  //     or
  //     node instanceof TaintedPathWorse::Sanitizer
  //   }

  //   override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
  //     guard instanceof TaintedObject::SanitizerGuard
  //   }
  
  //   override predicate isAdditionalFlowStep(
  //     DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  //   ) {
  //     TaintedPathWorse::isAdditionalTaintedPathFlowStep(src, trg, inlbl, outlbl)
  //   }
  // }
}