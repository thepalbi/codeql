/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * NoSQL injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.TaintedObject
import evaluation.NoSQLWorse

module NosqlInjectionWorse {
  /**
   * A data flow source for NoSQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the type of data coming from this source.
     */
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A data flow sink for NoSQL injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a flow label relevant for this sink.
     *
     * Defaults to deeply tainted objects only.
     */
    DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  /**
   * A sanitizer for NoSQL injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for NoSQL injection. */
  private class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }

    override DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
  }

  /** A source of user-controlled objects. */
  private class TaintedObjectSource extends Source {
    TaintedObjectSource() { this instanceof TaintedObject::Source }

    override DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  /** An expression interpreted as a NoSQL query, viewed as a sink. */
  private class NosqlQuerySinkWorse extends Sink, DataFlow::ValueNode {
    override NoSQLWorse::Query astNode;
  }
}