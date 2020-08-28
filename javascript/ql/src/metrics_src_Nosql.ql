
import javascript
import PropagationGraphs
import Metrics
import metrics_san
import tsm_nosql_worse
import TSMNosqlWorse
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
    score = sum(doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
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
