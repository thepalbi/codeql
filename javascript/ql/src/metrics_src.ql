import javascript
import PropagationGraphs
import metrics
import scores_dombasedxss_005_noflows


query predicate predictionsSource(DataFlow::Node node, PropagationGraph::Node pnode, 
    float score, boolean isKnown, boolean isCandidate, string type, string crep){
    node = pnode.asDataFlowNode() 
    and 
    exists(pnode.rep())
    and
    score = sum(ReprScores::getReprScore(pnode.rep(), "src"))/count(pnode.rep())
    and 
    ((isKnown = true and Metrics::isKnownNoSqlInjectionSource(pnode)) or (isKnown = false and not Metrics::isKnownNoSqlInjectionSource(pnode))) 
    and
    ((pnode.isSourceCandidate() and Metrics::getSrcType(node) = type and isCandidate = true )
    or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
    and
    crep = pnode.getconcatrep()
}