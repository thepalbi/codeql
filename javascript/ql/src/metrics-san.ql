import javascript
import PropagationGraphs
import metrics
import scores_dombasedxss_050_noflows

query predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(ReprScores::getReprScore(pnode.rep(), "san"))/count(pnode.rep())
    and 
    ((isKnown = true and Metrics::isKnownDomBasedXssSanitizer(pnode)) or (isKnown = false and not Metrics::isKnownDomBasedXssSanitizer(pnode))) 
    and
    ((pnode.isSanitizerCandidate() and isCandidate = true )
    or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
    and
    type = "call"
    and
    crep = pnode.getconcatrep()   
}