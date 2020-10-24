import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.TaintedPathCustomizationsWorse

predicate pathKnownSanitizer(DataFlow::Node node){
    node instanceof TaintedPathWorse::Sanitizer or
    (not node instanceof TaintedPath::Sanitizer and Metrics::isKnownSanitizer(node))
}

// query predicate predictionsPathsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and pathKnownSanitizer(node)) 
//         or (isKnown = false and not pathKnownSanitizer(node))
//     ) 
// }

query predicate getTSMWorseScoresPathsan(DataFlow::Node node, float score){
    node instanceof TaintedPath::Sanitizer and
    not node instanceof TaintedPathWorse::Sanitizer  and
    TSM::isSanitizer(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredPathsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    Metrics::isKnownTaintedPathSanitizer(node) and
    TSM::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (
        pathKnownSanitizer(node) and isKnown = true or
        not pathKnownSanitizer(node) and isKnown = false
        ) 
    and score > 0
}