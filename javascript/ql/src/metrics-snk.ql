import javascript
import PropagationGraphs
import metrics
//import scores_nosqlinjection_045
import CommandInjection
import tsm_nosql1
import tsm_nosql2
import tsm_nosql3
//import tsm_nosql4
//import tsm_nosql5
import tsm_nosql6
import tsm_nosql_worse
import tsm_sql_worse
import tsm_xss_worse
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations1
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations2
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations3
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations4
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations5
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations6
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse
//import semmle.javascript.security.dataflow.DomBasedXss
//import semmle.javascript.security.dataflow.DomBasedXssWorse
import NodeRepresentation



predicate isSource(PropagationGraph::Node n){
    n.isSourceCandidate()
}

predicate isStep(PropagationGraph::Node n1, PropagationGraph::Node n2){
    PropagationGraph::edge(n1, n2)
}

predicate shortestPathLength(PropagationGraph::Node n1, PropagationGraph::Node n2, int length) =
   shortestDistances(isSource/1, isStep/2)(n1, n2, length)

predicate getEdgeLength(PropagationGraph::Node n1, PropagationGraph::Node n2, int length){  
    n2.isSinkCandidate() and
    shortestPathLength(n1, n2, length)
}

predicate getEdgeStats(int maxPathLength, float avgPathLength){
    maxPathLength = max(int l | exists(PropagationGraph::Node n1, PropagationGraph::Node n2 | getEdgeLength(n1, n2, l)) and l > 0) and
    avgPathLength = avg(int l | exists(PropagationGraph::Node n1, PropagationGraph::Node n2 | getEdgeLength(n1, n2, l)) and l > 0) 
}

predicate xssKnownSink(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sink or
    (not node instanceof DomBasedXss::Sink and Metrics::isKnownSink(node))
}

predicate sqlKnownSink(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Sink or
    (not node instanceof SqlInjection::Sink and Metrics::isKnownSink(node))
}

predicate nosqlKnownSink(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Sink or
    (not node instanceof NosqlInjection::Sink and Metrics::isKnownSink(node))
}

predicate noReps(DataFlow::Node node){
    node instanceof SqlInjection::Sink and
    not node instanceof SqlInjectionWorse::Sink  and
    //not exists (PropagationGraph::Node n | n.asDataFlowNode() = node) and
    not exists(candidateRep(node, _))
}

query predicate getTSMWorseScoresXss(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Sink and
    not node instanceof DomBasedXssWorse::Sink  and
    TSMXssWorse::isSink(node, score)
}


query predicate getTSMWorseFilteredXss(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMXssWorse::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (xssKnownSink(node) and isKnown = true or
    not xssKnownSink(node) and isKnown = false )
    and rep = PropagationGraph::getconcatrep(node) and
    score > 0
}


predicate getTSMWorseScoresSql(DataFlow::Node node, float score){
    node instanceof SqlInjection::Sink and
    not node instanceof SqlInjectionWorse::Sink  and
    TSMSqlWorse::isSink(node, score)
}

predicate getTSMWorseFilteredSql(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMSqlWorse::isSink(node, score)  and
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

 predicate getTSMWorseScoresNoSql(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Sink and
    not node instanceof NosqlInjectionWorse::Sink  and
    TSMNoSqlWorse::isSink(node, score)
}

 predicate getTSMWorseFilteredNoSql(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    Metrics::isSinkCandidate(node) and
    TSMNoSqlWorse::isSink(node, score)  and
    (Metrics::isEffectiveSink(node) and filtered = true or
    not  Metrics::isEffectiveSink(node) and filtered = false) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node)
}

predicate getTSMWorseFilteredNoSql2(DataFlow::Node node, float score, boolean isKnown, boolean isNoSqlWorse, string rep){
    Metrics::isSinkCandidate(node) and
    TSMNoSqlWorse::isSink(node, score)  and
    ( node instanceof NosqlInjection::Sink and not node instanceof NosqlInjectionWorse::Sink and isNoSqlWorse = true or
    not node instanceof NosqlInjection::Sink and isNoSqlWorse = false ) and
    (nosqlKnownSink(node) and isKnown = true or
    not nosqlKnownSink(node) and isKnown = false )
    // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
    // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
    and rep =  PropagationGraph::getconcatrep(node) and
    score > 0
}
