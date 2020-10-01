/**
 * @kind graph
 */

/*
 * Splitted in several files to avoid the BDD  compiler error... 
 */

 import javascript
import PropagationGraphs
import metrics
import tsm
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

// query predicate predictionsNoSqlsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and nosqlKnownSink(node)) 
//         or (isKnown = false and not nosqlKnownSink(node))
//     )     
// }


// query predicate predictionsNoSqlsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and nosqlKnownSanitizer(node)) 
//         or (isKnown = false and not nosqlKnownSanitizer(node))
//     ) 
// }

// query predicate predictionsNoSqlsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and nosqlKnownSource(node)) 
//         or (isKnown = false and not nosqlKnownSource(node))
//     ) 
// }

// predicate nosqlKnownSanitizer(DataFlow::Node node){
//     node instanceof NosqlInjectionWorse::Sanitizer or
//     (not node instanceof NosqlInjection::Sanitizer and Metrics::isKnownSanitizer(node))
// }

// predicate nosqlKnownSink(DataFlow::Node node){
//     node instanceof NosqlInjectionWorse::Sink or
//     (not node instanceof NosqlInjection::Sink and Metrics::isKnownSink(node))
// }

// predicate nosqlKnownSource(DataFlow::Node node){
//     node instanceof NosqlInjectionWorse::Source or
//     (not node instanceof NosqlInjection::Source and Metrics::isKnownSource(node))
// }

// query predicate getTSMWorseScoresNoSqlsrc(DataFlow::Node node, float score){
//     node instanceof NosqlInjection::Source and
//     not node instanceof NosqlInjectionWorse::Source  and
//     TSMNosql::isSource(node, score)
// }

// query predicate getTSMWorseFilteredNoSqlsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {
//     Metrics::isSourceCandidate(node) and
//     Metrics::isKnownNoSqlInjectionSource(node) and
//     TSM::isSource(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (nosqlKnownSource(node) and isKnown = true or
//     not nosqlKnownSource(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }

// query predicate getTSMWorseScoresNoSqlsan(DataFlow::Node node, float score){
//     node instanceof NosqlInjection::Sanitizer and
//     not node instanceof NosqlInjectionWorse::Sanitizer  and
//     TSM::isSanitizer(node, score)
// }

// query predicate getTSMWorseFilteredNoSqlsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
//     Metrics::isSanitizerCandidate(node) and
//     Metrics::isKnownNoSqlInjectionSanitizer(node) and
//     TSM::isSanitizer(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (nosqlKnownSanitizer(node) and isKnown = true or
//     not nosqlKnownSanitizer(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }

// query predicate getTSMWorseScoresNoSqlsnk(DataFlow::Node node, float score){
//     node instanceof NosqlInjection::Sink and
//     not node instanceof NosqlInjectionWorse::Sink  and
//     TSM::isSink(node, score)
// }

// query  predicate getTSMWorseFilteredNoSqlsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
//     Metrics::isSinkCandidate(node) and
//     TSM::isSink(node, score)  and
//     (Metrics::isEffectiveSink(node) and filtered = true or
//     not  Metrics::isEffectiveSink(node) and filtered = false) and
//     (nosqlKnownSink(node) and isKnown = true or
//     not nosqlKnownSink(node) and isKnown = false )
//     // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
//     // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
//     and rep =  PropagationGraph::getconcatrep(node)
// }

// query predicate getTSMWorseFilteredNoSql2snk(DataFlow::Node node, float score, boolean isKnown, boolean isNoSqlWorse, string rep){
//     Metrics::isSinkCandidate(node) and
//     TSM::isSink(node, score)  and
//     ( node instanceof NosqlInjection::Sink and not node instanceof NosqlInjectionWorse::Sink and isNoSqlWorse = true or
//     not node instanceof NosqlInjection::Sink and isNoSqlWorse = false ) and
//     (nosqlKnownSink(node) and isKnown = true or
//     not nosqlKnownSink(node) and isKnown = false )
//     // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
//     // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
//     and rep =  PropagationGraph::getconcatrep(node) and
//     score > 0
// }



