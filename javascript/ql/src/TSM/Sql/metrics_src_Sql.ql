/**
 * @kind graph
 */
import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse

predicate sqlKnownSource(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Source or
    (not node instanceof SqlInjection::Source and Metrics::isKnownSource(node))
}

// query predicate predictionsSqlsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSource(node)) 
//         or (isKnown = false and not sqlKnownSource(node))
//     ) 
// }

query predicate getTSMWorseScoresSqlsrc(DataFlow::Node node, float score){
    node instanceof SqlInjection::Source and
    not node instanceof SqlInjectionWorse::Source  and
    TSM::isSource(node, score)
    //and score > 0
}

query predicate getTSMWorseFilteredSqlsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownSqlInjectionSource(node) and
    TSM::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (sqlKnownSource(node) and isKnown = true or
    not sqlKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}