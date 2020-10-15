/**
 * Provides a taint tracking configuration for reasoning about SQL injection
 * vulnerabilities.
 */

import javascript


module Seldon {  
    import semmle.javascript.security.dataflow.SeldonCustomizations::Seldon

  /**
   * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "Seldon" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
 
}


