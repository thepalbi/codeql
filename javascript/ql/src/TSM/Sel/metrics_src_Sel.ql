/**
 * @kind graph
 */
import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.SeldonCustomizationsWorse
import semmle.javascript.security.dataflow.SeldonCustomizations

predicate isCandidateSeldonSource(DataFlow::Node node){
    node instanceof Seldon::Source
}

predicate seldonKnownSource(DataFlow::Node node){
    node instanceof SeldonWorse::Source or
    (not node instanceof Seldon::Source and Metrics::isKnownSource(node))
}

// query predicate predictionsSqlsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSource(node)) 
//         or (isKnown = false and not sqlKnownSource(node))
//     ) 
// }

query predicate getTSMWorseScoresSelsrc(DataFlow::Node node, float score){
    node instanceof Seldon::Source and
    not node instanceof SeldonWorse::Source  and
    TSM::isSource(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredSelsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    isCandidateSeldonSource(node) and
    TSM::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (seldonKnownSource(node) and isKnown = true or
    not seldonKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}