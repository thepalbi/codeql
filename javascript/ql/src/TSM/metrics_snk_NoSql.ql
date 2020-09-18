/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics_snk
import tsm_nosql_worse
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

predicate nosqlKnownSink(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Sink or
    (not node instanceof NosqlInjection::Sink and Metrics::isKnownSink(node))
}

query predicate getTSMWorseScoresNoSql(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Sink and
    not node instanceof NosqlInjectionWorse::Sink  and
    TSMNosqlWorse::isSink(node, score)
}

query  predicate getTSMWorseFilteredNoSql(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMNosqlWorse::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node)
}

query predicate getTSMWorseFilteredNoSql2(DataFlow::Node node, float score, boolean isKnown, boolean isNoSqlWorse, string rep){
    Metrics::isSinkCandidate(node) and
    TSMNosqlWorse::isSink(node, score)  and
    ( node instanceof NosqlInjection::Sink and not node instanceof NosqlInjectionWorse::Sink and isNoSqlWorse = true or
    not node instanceof NosqlInjection::Sink and isNoSqlWorse = false ) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node) and
    score > 0
}



