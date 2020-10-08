import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.SeldonCustomizationsWorse
import semmle.javascript.security.dataflow.SeldonCustomizations


predicate seldonKnownSanitizer(DataFlow::Node node){
    node instanceof SeldonWorse::Sanitizer or
    (not node instanceof Seldon::Sanitizer and Metrics::isKnownSanitizer(node))
}

predicate isKnownSeldonSanitizer(DataFlow::Node node){
    node instanceof Seldon::Sanitizer
    }
    

// query predicate predictionsSqlsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and sqlKnownSanitizer(node)) 
//         or (isKnown = false and not sqlKnownSanitizer(node))
//     ) 
// }

query predicate getTSMWorseScoresSelsan(DataFlow::Node node, float score){
    node instanceof Seldon::Sanitizer and
    not node instanceof SeldonWorse::Sanitizer  and
    TSM::isSanitizer(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredSelsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    isKnownSeldonSanitizer(node) and
    TSM::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (
        seldonKnownSanitizer(node) and isKnown = true or
        not seldonKnownSanitizer(node) and isKnown = false
        ) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}