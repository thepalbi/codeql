/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics_snk
import tsm_sql
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse

predicate sqlKnownSink(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Sink or
    (not node instanceof SqlInjection::Sink and Metrics::isKnownSink(node))
}

// query predicate predictionsSqlsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSink(node)) 
//         or (isKnown = false and not sqlKnownSink(node))
//     )     
// }

query predicate getTSMWorseScoresSqlsnk(DataFlow::Node node, float score){
    node instanceof SqlInjection::Sink and
    not node instanceof SqlInjectionWorse::Sink  and
    TSMSql::isSink(node, score)
}

query  predicate getTSMWorseFilteredSqlsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMSql::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (sqlKnownSink(node) and isKnown = true or
    not sqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    //and rep = node.getconcatrep() //and
    //score > 0
    and rep = PropagationGraph::getconcatrep(node) 
}


