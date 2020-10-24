/**
 * @kind graph
 */
import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.TaintedPathCustomizationsWorse

predicate pathKnownSource(DataFlow::Node node){
    node instanceof TaintedPathWorse::Source or
    (not node instanceof TaintedPath::Source and Metrics::isKnownSource(node))
}

// query predicate predictionsPathsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and pathKnownSource(node)) 
//         or (isKnown = false and not pathKnownSource(node))
//     ) 
// }

query predicate getTSMWorseScoresPathsrc(DataFlow::Node node, float score){
    node instanceof TaintedPath::Source and
    not node instanceof TaintedPathWorse::Source  and
    TSM::isSource(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredPathsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownTaintedPathSource(node) and
    TSM::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (pathKnownSource(node) and isKnown = true or
    not pathKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}