/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

predicate nosqlKnownSink(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Sink or
    (not node instanceof NosqlInjection::Sink and Metrics::isKnownSink(node))
}

// query predicate predictionsNoSqlsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and nosqlKnownSink(node)) 
//         or (isKnown = false and not nosqlKnownSink(node))
//     )     
// }

query predicate getTSMWorseScoresNoSqlsnk(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Sink and
    not node instanceof NosqlInjectionWorse::Sink  and
    TSM::isSink(node, score)
}

query  predicate getTSMWorseFilteredNoSqlsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSM::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node)
}

query predicate getTSMWorseFilteredNoSql2snk(DataFlow::Node node, float score, boolean isKnown, boolean isNoSqlWorse, string rep){
    Metrics::isSinkCandidate(node) and
    TSM::isSink(node, score)  and
    ( node instanceof NosqlInjection::Sink and not node instanceof NosqlInjectionWorse::Sink and isNoSqlWorse = true or
    not node instanceof NosqlInjection::Sink and isNoSqlWorse = false ) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node) and
    score > 0
}



