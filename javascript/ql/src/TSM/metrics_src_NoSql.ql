
import javascript
import PropagationGraphs
import Metrics
import metrics_src
import tsm_nosql_worse
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate nosqlKnownSource(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Source or
    (not node instanceof NosqlInjection::Source and Metrics::isKnownSource(node))
}

query predicate predictionsSource(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(TSMNosqlWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
    and 
    (   (isKnown = true and nosqlKnownSource(node)) 
        or (isKnown = false and not nosqlKnownSource(node))
    ) 
    and
    ((pnode.isSourceCandidate() and Metrics::getSrcType(node) = type and isCandidate = true )
    or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
    and
    crep = pnode.getconcatrep()
}

query predicate getTSMWorseScoresSql(DataFlow::Node node, float score){
    node instanceof NosqlInjection::Source and
    not node instanceof NosqlInjectionWorse::Source  and
    TSMNosqlWorse::isSource(node, score)
}

query predicate getTSMWorseFilteredSql(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownNoSqlInjectionSource(node) and
    TSMNosqlWorse::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (nosqlKnownSource(node) and isKnown = true or
    not nosqlKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}