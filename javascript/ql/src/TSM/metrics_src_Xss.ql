
import javascript
import PropagationGraphs
import Metrics
import metrics_src
import tsm_xss
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

predicate xssKnownSource(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Source or
    (not node instanceof DomBasedXss::Source and Metrics::isKnownSource(node))
}

// query predicate predictionsXssSrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     // node = pnode.asDataFlowNode() 
//     // and 
//     // exists(pnode.rep())
//     // and
//     // score = sum(TSMXssWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
//     and 
//     (   (isKnown = true and xssKnownSource(node)) 
//         or (isKnown = false and not xssKnownSource(node))
//     ) 
//     // and
//     // ((pnode.isSourceCandidate() and Metrics::getSrcType(node) = type and isCandidate = true )
//     // or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
//     // and
//     // crep = pnode.getconcatrep()
// }

query predicate getTSMWorseScoresSqlsrc(DataFlow::Node node, float score){
    node instanceof DomBasedXss::Source and
    not node instanceof DomBasedXssWorse::Source  and
    TSMXss::isSource(node, score)
}

query predicate getTSMWorseFilteredSqlsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
    Metrics::isSourceCandidate(node) and
    Metrics::isKnownDomBasedXssSource(node) and
    TSMXss::isSource(node, score) and     
    rep = PropagationGraph::getconcatrep(node) 
    and (xssKnownSource(node) and isKnown = true or
    not xssKnownSource(node) and isKnown = false) 
    // and filtered = true
    // // and (Metrics::isEffectiveSource(node) and filtered = true or
    // // not  Metrics::isEffectiveSource(node) and filtered = false) and
    and score > 0
}