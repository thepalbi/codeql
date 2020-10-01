/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSink(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sink or
    (not node instanceof DomBasedXss::Sink and Metrics::isKnownSink(node))
}

predicate xssKnownSource(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Source or
    (not node instanceof DomBasedXss::Source and Metrics::isKnownSource(node))
}


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

// query predicate predictionsXsssnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep) and
//     and 
//     (   (isKnown = true and xssKnownSink(node)) 
//         or (isKnown = false and not xssKnownSink(node))
//     )     
// }

// query predicate predictionsXssSrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and xssKnownSource(node)) 
//         or (isKnown = false and not xssKnownSource(node))
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


query predicate getTSMWorseScoresXsssrc(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Source and
    not node instanceof DomBasedXssWorse::Source  and
    TSM::isSource(node, score)
}

query predicate getTSMWorseFilteredXsssrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownDomBasedXssSource(node) and
    TSM::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (xssKnownSource(node) and isKnown = true or
    not xssKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}

query predicate getTSMWorseScoresXsssan(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Sanitizer and
    not node instanceof DomBasedXssWorse::Sanitizer  and
    TSM::isSanitizer(node, score)
}

query predicate getTSMWorseFilteredXsssan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSanitizerCandidate(node) and
    Metrics::isKnownDomBasedXssSanitizer(node) and
    TSM::isSanitizer(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (xssKnownSanitizer(node) and isKnown = true or
    not xssKnownSanitizer(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}