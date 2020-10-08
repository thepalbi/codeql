/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.SeldonCustomizationsWorse
import semmle.javascript.security.dataflow.SeldonCustomizations

predicate isCandidateSeldonSink(DataFlow::Node node){
    node instanceof Seldon::Sink
}

predicate seldonKnownSink(DataFlow::Node node){
    node instanceof SeldonWorse::Sink or
    (not node instanceof Seldon::Sink and Metrics::isKnownSink(node))
}

    
// query predicate predictionsSqlsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSink(node)) 
//         or (isKnown = false and not sqlKnownSink(node))
//     )     
// }

query predicate getTSMWorseScoresSelsnk(DataFlow::Node node, float score){
    node instanceof Seldon::Sink and
    not node instanceof SeldonWorse::Sink  and
    TSM::isSink(node, score)
}

query  predicate getTSMWorseFilteredSelsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    isCandidateSeldonSink(node) and
    TSM::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (seldonKnownSink(node) and isKnown = true or
    not seldonKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    //and rep = node.getconcatrep() //and
    //score > 0
    and rep = PropagationGraph::getconcatrep(node) 
}


