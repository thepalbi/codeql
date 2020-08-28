import javascript
import PropagationGraphs
import Metrics
import metrics_san
import tsm_repr_pred
import tsm_sql_worse
import TSMNosqlWorse
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

predicate nosqlKnownSanitizer(DataFlow::Node node){
    node instanceof NosqlInjectionWorse::Sanitizer or
    (not node instanceof NosqlInjection::Sanitizer and Metrics::isKnownSanitizer(node)(node))
}


query predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(doGetReprScore(pnode.rep(), "san"))/count(pnode.rep())
    and 
    (   (isKnown = true and nosqlKnownSanitizer(node)) 
        or (isKnown = false and not nosqlKnownSanitizer(node))
    ) 
    and
    ((pnode.isSanitizerCandidate() and isCandidate = true )
    or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
    and
    type = "call"
    and
    crep = pnode.getconcatrep()   
}