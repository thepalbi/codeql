import javascript
import PropagationGraphs
import Metrics
import metrics_san
import tsm_xss
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSanitizer(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sanitizer or
    (not node instanceof DomBasedXss::Sanitizer and Metrics::isKnownSanitizer(node))
}

// query predicate predictionsXsssan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and   
//     (   (isKnown = true and xssKnownSanitizer(node)) 
//         or (isKnown = false and not xssKnownSanitizer(node))
//     ) 
// }


query predicate getTSMWorseScoresSqlsan(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Sanitizer and
    not node instanceof DomBasedXssWorse::Sanitizer  and
    TSMXss::isSanitizer(node, score)
}

query predicate getTSMWorseFilteredSqlsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    Metrics::isKnownDomBasedXssSanitizer(node) and
    TSMXss::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (xssKnownSanitizer(node) and isKnown = true or
    not xssKnownSanitizer(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}