import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

predicate nosqlKnownSanitizer(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Sanitizer or
    (not node instanceof NosqlInjection::Sanitizer and Metrics::isKnownSanitizer(node))
}


// query predicate predictionsNoSqlsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and nosqlKnownSanitizer(node)) 
//         or (isKnown = false and not nosqlKnownSanitizer(node))
//     ) 
// }

query predicate getTSMWorseScoresNoSqlsan(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Sanitizer and
    not node instanceof NosqlInjectionWorse::Sanitizer  and
    TSM::isSanitizer(node, score)
}

query predicate getTSMWorseFilteredNoSqlsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    Metrics::isKnownNoSqlInjectionSanitizer(node) and
    TSM::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (nosqlKnownSanitizer(node) and isKnown = true or
    not nosqlKnownSanitizer(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}