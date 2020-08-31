/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics_snk
import tsm_xss_worse
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSink(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sink or
    (not node instanceof DomBasedXss::Sink and Metrics::isKnownSink(node))
}

query predicate getTSMWorseScoresXss(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Sink and
    not node instanceof DomBasedXssWorse::Sink  and
    TSMXssWorse::isSink(node, score)
}

query predicate getTSMWorseFilteredXss(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMXssWorse::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (xssKnownSink(node) and isKnown = true or
    not xssKnownSink(node) and isKnown = false )
    and rep = PropagationGraph::getconcatrep(node) and
    score > 0
}


