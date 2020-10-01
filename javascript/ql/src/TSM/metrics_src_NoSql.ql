
import javascript
import PropagationGraphs
import Metrics
import metrics_src
import tsm_nosql
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate nosqlKnownSource(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Source or
    (not node instanceof NosqlInjection::Source and Metrics::isKnownSource(node))
}

// query predicate predictionsNoSqlsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and nosqlKnownSource(node)) 
//         or (isKnown = false and not nosqlKnownSource(node))
//     ) 
// }

query predicate getTSMWorseScoresSqlsrc(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Source and
    not node instanceof NosqlInjectionWorse::Source  and
    TSMNosql::isSource(node, score)
}

query predicate getTSMWorseFilteredSqlsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownNoSqlInjectionSource(node) and
    TSMNosql::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (nosqlKnownSource(node) and isKnown = true or
    not nosqlKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}