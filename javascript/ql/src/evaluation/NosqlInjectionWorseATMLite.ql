/**
 * @name NoSQL injection worse (ATM Lite)
 * @description ATM Lite variant of NoSQL injection worse
 * @problem.severity error
 */

import javascript
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import NosqlInjectionWorseEndpointFilters as NosqlInjectionWorseEndpointFilters
import NosqlInjectionWorseCustomizations

/**
 * This predicate allows us to propagate data flow through property writes and array constructors
 * within a query object, enabling the security query to pick up NoSQL injection vulnerabilities
 * involving compound queries.
 */
private DataFlow::Node getASubexpressionWithinQuery(DataFlow::SourceNode query) {
  result = getASubexpressionWithinQuery*(query).(DataFlow::SourceNode).getAPropertyWrite().getRhs() or
  result = getASubexpressionWithinQuery*(query).(DataFlow::ArrayCreationNode).getAnElement()
}

class NosqlInjectionWorseATMLiteConfig extends ATMConfig {
  NosqlInjectionWorseATMLiteConfig() { this = "NosqlInjectionWorseATMLiteConfig" }

  override predicate isKnownSource(DataFlow::Node source) {
    source instanceof NosqlInjectionWorse::Source
  }

  override predicate isKnownSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    TaintedObject::isSource(source, lbl)
  }

  override predicate isKnownSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
    sink.(NosqlInjectionWorse::Sink).getAFlowLabel() = lbl
  }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    NosqlInjectionWorseEndpointFilters::isEffectiveSink(sinkCandidate)
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
    exists(NoSQLWorse::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsToExpr(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
    or
    // relaxed version of previous step to track taint through unmodelled NoSQL query objects
    any(ATM::Configuration cfg).isSink(trg) and
    src = getASubexpressionWithinQuery(trg)
  }
}

from
  ATM::Configuration cfg, DataFlow::Node source, DataFlow::Node sink, string filePathSink,
  int startLineSink, int endLineSink, int startColumnSink, int endColumnSink, string filePathSource,
  int startLineSource, int endLineSource, int startColumnSource, int endColumnSource, float score
where
  cfg.hasFlow(source, sink) and
  not ATM::ResultsInfo::isFlowLikelyInBaseQuery(source, sink) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  source
      .hasLocationInfo(filePathSource, startLineSource, startColumnSource, endLineSource,
        endColumnSource) and
  score = 0
select source, startLineSource, startColumnSource, endLineSource, endColumnSource, filePathSource,
  sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink, startLineSource,
  startColumnSource, endLineSource, endColumnSource, filePathSource, startLineSink, startColumnSink,
  endLineSink, endColumnSink, filePathSink, score
