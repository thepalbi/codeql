import javascript
import PropagationGraphs
import Metrics
import metrics_san
import tsm_repr_pred
import tsm_xss_worse
import TSMXssWorse
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSanitizer(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sanitizer or
    (not node instanceof DomBasedXss::Sanitizer and Metrics::isKnownSanitizer(node)(node))
}


query predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(doGetReprScore(pnode.rep(), "san"))/count(pnode.rep())
    and 
    (   (isKnown = true and xssKnownSanitizer(node)) 
        or (isKnown = false and not xssKnownSanitizer(node))
    ) 
    and
    ((pnode.isSanitizerCandidate() and isCandidate = true )
    or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
    and
    type = "call"
    and
    crep = pnode.getconcatrep()   
}