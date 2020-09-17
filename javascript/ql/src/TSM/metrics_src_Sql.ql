
import javascript
import PropagationGraphs
import Metrics
import metrics_src
import tsm_sql_worse
import TSMSqlWorse
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse

predicate sqlKnownSource(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Source or
    (not node instanceof SqlInjection::Source and Metrics::isKnownSource(node))
}

query predicate predictionsSource(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
    and 
    (   (isKnown = true and sqlKnownSource(node)) 
        or (isKnown = false and not sqlKnownSource(node))
    ) 
    and
    ((pnode.isSourceCandidate() and Metrics::getSrcType(node) = type and isCandidate = true )
    or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
    and
    crep = pnode.getconcatrep()
}
