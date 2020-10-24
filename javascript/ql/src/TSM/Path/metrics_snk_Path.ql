/**
 * @kind graph
 */
import javascript
import TSM.TSM
import TSM.metrics
//import semmle.javascript.security.dataflow.TaintedPathWorse
import semmle.javascript.security.dataflow.TaintedPathCustomizations

predicate pathKnownSink(DataFlow::Node node){
    node instanceof TaintedPathWorse::Sink or
    (not node instanceof TaintedPath::Sink and Metrics::isKnownSink(node))
}

// query predicate predictionsPathsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and pathKnownSink(node)) 
//         or (isKnown = false and not pathKnownSink(node))
//     )     
// }

predicate test1(DataFlow::Node node, float score){
    not node instanceof TaintedPath::Sink and
    node instanceof TaintedPathWorse::Sink  
    // and TSM::isSink(node, score)
    and score = 1
}

predicate test2(DataFlow::Node node, float score){
    node instanceof TaintedPath::Sink and
    not node instanceof TaintedPathWorse::Sink  
    // and TSM::isSink(node, score)
    and score = 1
}

predicate test3(DataFlow::Node node, float score){
    node instanceof TaintedPath::Sink and
    node instanceof TaintedPathWorse::Sink  
    // and TSM::isSink(node, score)
    and score = 1
}




query predicate getTSMWorseScoresPathsnk(DataFlow::Node node, float score){
    node instanceof TaintedPath::Sink and
    not node instanceof TaintedPathWorse::Sink  and
    TSM::isSink(node, score)
}

query  predicate getTSMWorseFilteredPathsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSM::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (pathKnownSink(node) and isKnown = true or
    not pathKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NopathInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NopathInjectionWorse::Sink and isKnown = false    ) 
    //and rep = node.getconcatrep() //and
    //score > 0
    and rep = PropagationGraph::getconcatrep(node) 
}


