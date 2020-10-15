/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import semmle.javascript.security.dataflow.SeldonCustomizations
private float minScore_snk() { result = 0.1}
private float minScore_src() { result = 0.1}
private float minScore_san() { result = 0.6}

module SeldonTSM {
  import TSM.query.tsm

  /**
   * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SeldonTSM" }

    override predicate isSource(DataFlow::Node source) { 
      exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
      //or
      //source instanceof Seldon::Source
    }

    override predicate isSink(DataFlow::Node sink) { 
      exists (float score | TSM::isSink(sink, score) and score>=minScore_snk()) 
      //or
      //sink instanceof Seldon::Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      exists (float score | TSM::isSanitizer(node, score) and score>=minScore_san()) 
      // or
      // node instanceof Seldon::Sanitizer
    }
  }
}
