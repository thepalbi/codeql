import javascript
import PropagationGraphs
import metrics
//import scores_nosqlinjection_045
import CommandInjection
import tsm_nosql1
import tsm_nosql2
import tsm_nosql3
//import tsm_nosql4
//import tsm_nosql5
import tsm_nosql6
import tsm_nosql_worse
import tsm_sql_worse
import tsm_xss_worse
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations1
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations2
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations3
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations4
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations5
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations6
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse
//import semmle.javascript.security.dataflow.DomBasedXss
//import semmle.javascript.security.dataflow.DomBasedXssWorse
import NodeRepresentation

class TSMWorse extends string {
    TSMWorse() {
        this = "TSMWorse"
    }

    predicate getScores(DataFlow::Node node, float score) {
        doGetScores(node, score)
    }

    predicate getFiltered(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep) {
        doGetFiltered(node, score, isKnown, filtered, rep)
    }

    abstract predicate doGetScores(DataFlow::Node node, float score);
    abstract predicate doGetFiltered(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep);
}

class TSMWorseXss extends TSMWorse {
    override predicate doGetScores(DataFlow::Node node, float score) {
        node instanceof DomBasedXss::Sink and
        not node instanceof DomBasedXssWorse::Sink  and
        TSMXssWorse::isSink(node, score)
    }

    override predicate doGetFiltered(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep) {
        Metrics::isSinkCandidate(node) and
        TSMXssWorse::isSink(node, score)  and
        (Metrics::isEffectiveSink(node) and filtered = true or
        not  Metrics::isEffectiveSink(node) and filtered = false) and
        (xssKnownSink(node) and isKnown = true or
        not xssKnownSink(node) and isKnown = false )
        and rep = PropagationGraph::getconcatrep(node) and
        score > 0
    }
}

predicate xssKnownSink(DataFlow::Node node){
    node instanceof DomBasedXssWorse::Sink or
    (not node instanceof DomBasedXss::Sink and Metrics::isKnownSink(node))
}
