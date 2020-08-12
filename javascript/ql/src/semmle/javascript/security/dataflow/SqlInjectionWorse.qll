/**
 * Provides a taint tracking configuration for reasoning about SQL injection
 * vulnerabilities.
 */

import javascript

module SqlInjectionWorse {  
    import SqlInjectionCustomizationsWorse::SqlInjectionWorse

  /**
   * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SqlInjection" }

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

