/**
 * @kind graph
 */

 /*
  * Splitted in several files to avoid the BDD  compiler error... 
  */

import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse


// query predicate predictionsSqlsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSink(node)) 
//         or (isKnown = false and not sqlKnownSink(node))
//     )     
// }

// query predicate predictionsSqlsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and sqlKnownSanitizer(node)) 
//         or (isKnown = false and not sqlKnownSanitizer(node))
//     ) 
// }

// query predicate predictionsSqlsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and sqlKnownSource(node)) 
//         or (isKnown = false and not sqlKnownSource(node))
//     ) 
// }

// predicate sqlKnownSource(DataFlow::Node node){
//     node instanceof SqlInjectionWorse::Source or
//     (not node instanceof SqlInjection::Source and Metrics::isKnownSource(node))
// }

// predicate sqlKnownSanitizer(DataFlow::Node node){
//     node instanceof SqlInjectionWorse::Sanitizer or
//     (not node instanceof SqlInjection::Sanitizer and Metrics::isKnownSanitizer(node))
// }

// predicate sqlKnownSink(DataFlow::Node node){
//     node instanceof SqlInjectionWorse::Sink or
//     (not node instanceof SqlInjection::Sink and Metrics::isKnownSink(node))
// }

// query predicate getTSMWorseScoresSqlsnk(DataFlow::Node node, float score){
//     node instanceof SqlInjection::Sink and
//     not node instanceof SqlInjectionWorse::Sink  and
//     TSM::isSink(node, score)
// }

// query  predicate getTSMWorseFilteredSqlsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
//     Metrics::isSinkCandidate(node) and
//     TSM::isSink(node, score)  and
//     (Metrics::isEffectiveSink(node) and filtered = true or
//     not  Metrics::isEffectiveSink(node) and filtered = false) and
//     (sqlKnownSink(node) and isKnown = true or
//     not sqlKnownSink(node) and isKnown = false )
//     // (node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = true or
//     // not node.asDataFlowNode() instanceof NosqlInjectionWorse::Sink and isKnown = false    ) 
//     //and rep = node.getconcatrep() //and
//     //score > 0
//     and rep = PropagationGraph::getconcatrep(node) 
// }

// query predicate getTSMWorseScoresSqlsrc(DataFlow::Node node, float score){
//     node instanceof SqlInjection::Source and
//     not node instanceof SqlInjectionWorse::Source  and
//     TSM::isSource(node, score)
//     //and score > 0
// }

// query predicate getTSMWorseFilteredSqlsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
//     Metrics::isSourceCandidate(node) and
//     Metrics::isKnownSqlInjectionSource(node) and
//     TSM::isSource(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (sqlKnownSource(node) and isKnown = true or
//     not sqlKnownSource(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }

// query predicate getTSMWorseScoresSqlsan(DataFlow::Node node, float score){
//     node instanceof SqlInjection::Sanitizer and
//     not node instanceof SqlInjectionWorse::Sanitizer  and
//     TSM::isSanitizer(node, score)
//     //and score > 0
// }

// query predicate getTSMWorseFilteredSqlsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
//     Metrics::isSanitizerCandidate(node) and
//     Metrics::isKnownSqlInjectionSanitizer(node) and
//     TSM::isSanitizer(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (sqlKnownSanitizer(node) and isKnown = true or
//     not sqlKnownSanitizer(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }