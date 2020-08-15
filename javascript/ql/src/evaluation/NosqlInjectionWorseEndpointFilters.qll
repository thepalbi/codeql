private import javascript
private import experimental.adaptivethreatmodeling.ATMConfig
private import CoreKnowledgeWorse as CoreKnowledgeWorse
private import NosqlInjectionEndpointFilterBase as NosqlInjectionEndpointFilterBase
private import NoSQLWorse

predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
  NosqlInjectionEndpointFilterBase::isEffectiveSink(sinkCandidate) and
  exists(DataFlow::CallNode call |
    sinkCandidate = call.getAnArgument() and
    not (
      CoreKnowledgeWorse::isKnownLibrarySink(sinkCandidate) or
      CoreKnowledgeWorse::isKnownStepSrc(sinkCandidate) or
      CoreKnowledgeWorse::isUnlikelySink(sinkCandidate) or
      // Remove modeled database calls. Arguments to modeled calls are very likely to be modeled
      // as sinks if they are true positives. Therefore arguments that are not modeled as sinks
      // are unlikely to be true positives.
      // For NoSQL worse, we include the "worse" version of the modeling of database calls.
      call instanceof NoSQLWorse::QueryCallWorse or
      // Remove calls to APIs that aren't relevant to NoSQL injection
      call.getReceiver().asExpr() instanceof HTTP::RequestExpr or
      call.getReceiver().asExpr() instanceof HTTP::ResponseExpr
    )
  )
}
