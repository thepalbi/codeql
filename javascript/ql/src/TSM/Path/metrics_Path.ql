/**
 * @kind graph
 */

 /*
  * Splitted in several files to avoid the BDD  compiler error... 
  */

import javascript
import TSM.TSM
import TSM.metrics
import semmle.javascript.security.dataflow.TaintedPathCustomizationsWorse


// query predicate predictionsPathsnk(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSink(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and PathKnownSink(node)) 
//         or (isKnown = false and not PathKnownSink(node))
//     )     
// }

// query predicate predictionsPathsan(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSanitizer(node, pnode, score, isKnown, isCandidate, type, crep) and
//     (   (isKnown = true and PathKnownSanitizer(node)) 
//         or (isKnown = false and not PathKnownSanitizer(node))
//     ) 
// }

// query predicate predictionsPathsrc(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     Metrics::predictionsSource(node, pnode, score, isKnown, isCandidate, type, crep)
//     and 
//     (   (isKnown = true and PathKnownSource(node)) 
//         or (isKnown = false and not PathKnownSource(node))
//     ) 
// }

// predicate PathKnownSource(DataFlow::Node node){
//     node instanceof PathInjectionWorse::Source or
//     (not node instanceof PathInjection::Source and Metrics::isKnownSource(node))
// }

// predicate PathKnownSanitizer(DataFlow::Node node){
//     node instanceof PathInjectionWorse::Sanitizer or
//     (not node instanceof PathInjection::Sanitizer and Metrics::isKnownSanitizer(node))
// }

// predicate PathKnownSink(DataFlow::Node node){
//     node instanceof PathInjectionWorse::Sink or
//     (not node instanceof PathInjection::Sink and Metrics::isKnownSink(node))
// }

// query predicate getTSMWorseScoresPathsnk(DataFlow::Node node, float score){
//     node instanceof PathInjection::Sink and
//     not node instanceof PathInjectionWorse::Sink  and
//     TSM::isSink(node, score)
// }

// query  predicate getTSMWorseFilteredPathsnk(DataFlow::Node node, float score, boolean isKnown, boolean filtered, string rep){
//     Metrics::isSinkCandidate(node) and
//     TSM::isSink(node, score)  and
//     (Metrics::isEffectiveSink(node) and filtered = true or
//     not  Metrics::isEffectiveSink(node) and filtered = false) and
//     (PathKnownSink(node) and isKnown = true or
//     not PathKnownSink(node) and isKnown = false )
//     // (node.asDataFlowNode() instanceof NoPathInjectionWorse::Sink and isKnown = true or
//     // not node.asDataFlowNode() instanceof NoPathInjectionWorse::Sink and isKnown = false    ) 
//     //and rep = node.getconcatrep() //and
//     //score > 0
//     and rep = PropagationGraph::getconcatrep(node) 
// }

// query predicate getTSMWorseScoresPathsrc(DataFlow::Node node, float score){
//     node instanceof PathInjection::Source and
//     not node instanceof PathInjectionWorse::Source  and
//     TSM::isSource(node, score)
//     //and score > 0
// }

// query predicate getTSMWorseFilteredPathsrc(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
//     Metrics::isSourceCandidate(node) and
//     Metrics::isKnownPathInjectionSource(node) and
//     TSM::isSource(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (PathKnownSource(node) and isKnown = true or
//     not PathKnownSource(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }

// query predicate getTSMWorseScoresPathsan(DataFlow::Node node, float score){
//     node instanceof PathInjection::Sanitizer and
//     not node instanceof PathInjectionWorse::Sanitizer  and
//     TSM::isSanitizer(node, score)
//     //and score > 0
// }

// query predicate getTSMWorseFilteredPathsan(DataFlow::Node node, float score, boolean isKnown, string rep) {// , boolean isKnown, boolean filtered, string rep){
//     Metrics::isSanitizerCandidate(node) and
//     Metrics::isKnownPathInjectionSanitizer(node) and
//     TSM::isSanitizer(node, score) and     
//     rep = PropagationGraph::getconcatrep(node) 
//     and (PathKnownSanitizer(node) and isKnown = true or
//     not PathKnownSanitizer(node) and isKnown = false) 
//     // and filtered = true
//     // // and (Metrics::isEffectiveSource(node) and filtered = true or
//     // // not  Metrics::isEffectiveSource(node) and filtered = false) and
//     and score > 0
// }