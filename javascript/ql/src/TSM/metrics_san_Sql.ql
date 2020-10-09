import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse


predicate sqlKnownSanitizer(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Sanitizer or
    (not node instanceof SqlInjection::Sanitizer and Metrics::isKnownSanitizer(node))
}

// query predicate predictionsSqlsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and sqlKnownSanitizer(node)) 
//         or (isKnown = false and not sqlKnownSanitizer(node))
//     ) 
// }

query predicate getTSMWorseScoresSqlsan(DataFlow::Node node, float score){
    node instanceof SqlInjection::Sanitizer and
    not node instanceof SqlInjectionWorse::Sanitizer  and
    TSM::isSanitizer(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredSqlsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    Metrics::isKnownSqlInjectionSanitizer(node) and
    TSM::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (
        sqlKnownSanitizer(node) and isKnown = true or
        not sqlKnownSanitizer(node) and isKnown = false
        ) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}