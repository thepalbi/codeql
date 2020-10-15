/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import semmle.javascript.security.dataflow.TaintedPathCustomizations
private float minScore_snk() { result = 0.1}
private float minScore_src() { result = 0.1}
// Score>1 to ignore sanitizers
private float minScore_san() { result = 1.1}

module TSMConfig {
  import tsm

  /**
   * A taint-tracking configuration for reasoning about SQL injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TSMConfig" }

    override predicate isSource(DataFlow::Node source) { 
      exists (float score |  TSM::isSource(source, score) and score>=minScore_src()) 
      //or
      //source instanceof TaintedPath::Source
    }

    override predicate isSink(DataFlow::Node sink) { 
      exists (float score | TSM::isSink(sink, score) and score>=minScore_snk()) 
      //or
      //sink instanceof TaintedPath::Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      exists (float score | TSM::isSanitizer(node, score) and score>=minScore_san()) 
      or
      node instanceof TaintedPath::Sanitizer
    }
  }
}
