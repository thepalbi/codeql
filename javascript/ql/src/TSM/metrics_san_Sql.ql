import javascript
import PropagationGraphs
import Metrics
import metrics_san
import tsm_sql_worse
import TSMSqlWorse
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse


predicate sqlKnownSanitizer(DataFlow::Node node){
    node instanceof SqlInjectionWorse::Sanitizer or
    (not node instanceof SqlInjection::Sanitizer and Metrics::isKnownSanitizer(node))
}

query predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(doGetReprScore(pnode.rep(), "san"))/count(pnode.rep())
    and 
    (   (isKnown = true and sqlKnownSanitizer(node)) 
        or (isKnown = false and not sqlKnownSanitizer(node))
    ) 
    and
    ((pnode.isSanitizerCandidate() and isCandidate = true )
    or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
    and
    type = "call"
    and
    crep = pnode.getconcatrep()   
}