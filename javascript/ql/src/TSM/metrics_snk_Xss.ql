/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSink(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sink or
    (not node instanceof DomBasedXss::Sink and Metrics::isKnownSink(node))
}

// query predicate predictionsXsssnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and xssKnownSink(node)) 
//         or (isKnown = false and not xssKnownSink(node))
//     )     
// }

query predicate getTSMWorseScoresXsssnk(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Sink and
    not node instanceof DomBasedXssWorse::Sink  and
    TSM::isSink(node, score)
}

query predicate getTSMWorseFilteredXsssnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSM::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (xssKnownSink(node) and isKnown = true or
    not xssKnownSink(node) and isKnown = false )
    and rep = PropagationGraph::getconcatrep(node) and
    score > 0
}


