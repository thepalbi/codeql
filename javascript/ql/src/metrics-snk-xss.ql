
/**
 * @kind graph
 */
import javascript
import WorseMetrics

query predicate getTSMWorseScores(DataFlow::Node node, float score){
    WorseMetrics::TSMWorseXss::getScores(node, score)
}

query predicate getTSMWorseFilteredXss(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
    WorseMetrics::TSMWorseXss::getFiltered(node, score, isKnown, filtered, rep)
}
