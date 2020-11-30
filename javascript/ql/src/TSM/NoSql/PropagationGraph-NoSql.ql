/**
 * @kind graph
 * @id javascript/propagation-graph
 */

import javascript
import TSM.PropagationGraphsAlt
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

private string targetLibrary() { 
  result = "mongodb" 
  or result = "mongoose"
  // exists(API::Node imp | 
  //     imp = API::moduleImport(result)
  // )
}

predicate isSourceWorse(DataFlow::Node source) {
  source instanceof NosqlInjectionWorse::Source
}


// predicate reachableFromSourceCandidate(
//   PropagationGraph::SourceCandidate src, PropagationGraph::Node nd
// ) {
//   PropagationGraph::edge(src, nd)
//   or
//   exists(PropagationGraph::Node mid |
//     reachableFromSourceCandidate(src, mid) and 
//     PropagationGraph::edge(mid, nd)
//   )
// }

// predicate reachableFromSanitizerCandidate(
//   PropagationGraph::SanitizerCandidate san, PropagationGraph::Node nd
// ) {
//   PropagationGraph::edge(san, nd)
//   or
//   exists(PropagationGraph::Node mid |
//     reachableFromSanitizerCandidate(san, mid) and
//     PropagationGraph::edge(mid, nd)
//   )
// }

/**
 * Holds if there is a path from `src` through `san` to `snk` in the propagation graph,
 * which are source, sanitiser, and sink candidate, respectively.
 */
predicate triple(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk) {
  san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
  src != san and
  snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
  PropagationGraph::isSinkCandidate(_, snk)
}


// // print the set of connected triples
// predicate triple(
//   PropagationGraph::SourceCandidate src, PropagationGraph::SanitizerCandidate san, 
//   PropagationGraph::SinkCandidate snk) {
//   isSourceWorse(src.asDataFlowNode()) and
//   reachableFromSourceCandidate(src, san) and
//   src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//   isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
//   reachableFromSanitizerCandidate(san, snk) 
//   //snk.isSinkCandidate()  
//   // NB: we do not require `san` and `snk` to be different, since we might have a situation like
//   // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
// }

// predicate tripleWAtleastOneRep(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk) {
//   reachableFromSourceCandidate(src, san) and
//   san.isSanitizerCandidate() and
//   src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//   reachableFromSanitizerCandidate(san, snk) and
//   snk.isSinkCandidate()
//   // NB: we do not require `san` and `snk` to be different, since we might have a situation like
//   // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
// }

// predicate tripleWRepID(string ssrc, string ssan, string ssnk) {
//     exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
//     reachableFromSourceCandidate(src, san) and
//     san.isSanitizerCandidate() and
//     src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//     reachableFromSanitizerCandidate(san, snk) and
//     snk.isSinkCandidate() and     
//     ssrc = src.getconcatrep() and 
//     ssan = san.getconcatrep() and 
//     ssnk = snk.getconcatrep()
//     )
//     // NB: we do not require `san` and `snk` to be different, since we might have a situation like
//     // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
// }

// query predicate allCalls(PropagationGraph::Node callNode, int lineNumber, string repr) {
//   callNode = callNode and
//   callNode.asDataFlowNode().getStartLine() = lineNumber 
//   and repr = concat(callNode.rep(),"::")
// }


query predicate pairSanSnk(string ssan, string ssnk){
  exists(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk |
      isSourceWorse(src) and
      san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
      src.getEnclosingExpr() != san.getEnclosingExpr() and
      snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk, targetLibrary()) and
      PropagationGraph::isSinkCandidate(_, snk) and
      ssan = PropagationGraph::getconcatrep(san, false) and 
      ssnk = PropagationGraph::getconcatrep(snk, true)    
      )
}


query predicate pairSrcSan(string ssrc, string ssan){
  exists(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk |
    isSourceWorse(src) and
    san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
    src.getEnclosingExpr() != san.getEnclosingExpr() and
    snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
    // We keep only sinks that are candidates
    // (parameters of library functions)
    isCandidateSink(snk, targetLibrary()) and
    PropagationGraph::isSinkCandidate(_, snk) and
    ssan = PropagationGraph::getconcatrep(san, false) and 
    ssrc = PropagationGraph::getconcatrep(src, false)  
    )
  }

  predicate testSink(string ssnk, DataFlow::Node snk) {
    exists(DataFlow::Node src, DataFlow::Node san |
      isSourceWorse(src) and
      // san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
      src.getEnclosingExpr() != san.getEnclosingExpr() and
      snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk, targetLibrary()) and
      PropagationGraph::isSinkCandidate(_, snk) and
      ssnk = PropagationGraph::getconcatrep(snk, true) and 
      ssnk.indexOf("findOneAndUpdate")>0
      )
  }

// query predicate pairSanSnk(string ssan, string ssnk){
//   exists(PropagationGraph::SourceCandidate src, 
//       PropagationGraph::SanitizerCandidate san, 
//       PropagationGraph::SinkCandidate snk |
//       isSourceWorse(src.asDataFlowNode()) and
//       reachableFromSourceCandidate(src, san) and
//       src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//       reachableFromSanitizerCandidate(san, snk) and
//       // We keep only sinks that are candidates
//       // (parameters of library functions)
//       isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
//       ssan = san.getconcatrep(false) and 
//       ssnk = snk.getconcatrep(true)    
//       )
// }

// query predicate pairSrcSan(string ssrc, string ssan){
//   exists(PropagationGraph::SourceCandidate src, 
//     PropagationGraph::SanitizerCandidate san, 
//     PropagationGraph::SinkCandidate snk |
//     isSourceWorse(src.asDataFlowNode()) and
//     reachableFromSourceCandidate(src, san) and
//     src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//     reachableFromSanitizerCandidate(san, snk) and
//     // We keep only sinks that are candidates
//     // (parameters of library functions)
//     isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
//     ssan = san.getconcatrep(false) and 
//     ssrc = src.getconcatrep(false)  
//     )
//   }

// predicate pairSrcSanFew(string ssrc, string ssan){
//   exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
//     isSourceWorse(src.asDataFlowNode()) and
//       reachableFromSourceCandidate(src, san) and
//       san.isSanitizerCandidate() and
//       src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//       reachableFromSanitizerCandidate(san, snk) and
//       snk.isSinkCandidate() and 
//       // We keep only sinks that are candidates
//       // (parameters of library functions)
//       isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
//       ssrc = src.getconcatrep(false) and 
//       ssan = san.getconcatrep(false)  
//       //ssnk = snk.getconcatrep()    
//       //ssrc = getconcatrep(src) and 
//       //ssan = getconcatrep(san) 
//       )
// }

// predicate pairSanSnkFew(string ssan, string ssnk){
//     exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
//       isSourceWorse(src.asDataFlowNode()) and
//       reachableFromSourceCandidate(src, san) and
//         san.isSanitizerCandidate() and
//         src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
//         reachableFromSanitizerCandidate(san, snk) and
//         snk.isSinkCandidate() and         
//         // We keep only sinks that are candidates
//         // (parameters of library functions)
//         isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
//         ssan = san.getconcatrep(false) and 
//         ssnk = snk.getconcatrep(true)    
//         )
// }

// predicate tripleWEventType(string ssrc, string ssan, string ssnk) {
//     exists(PropagationGraph::Node src, PropagationGraph::Node san, PropagationGraph::Node snk |
//     triple(src, san, snk) and
//     ssrc = src.getId() and
//     ssan = san.getId() and
//     ssnk = snk.getId()
//     )
// }

query predicate eventToConcatRep(DataFlow::Node n, string repr){
  repr = PropagationGraph::getconcatrep(n, _)
}

// query predicate eventToConcatRep(PropagationGraph::Node n, string repr){
//     repr = n.getconcatrep()
// }

// class NodeWithFewReps extends PropagationGraph::Node {
//   NodeWithFewReps() { strictcount(rep()) >= 1 }
  
//   string toStr() {
//     result = strictconcat(string repr | repr = rep() | repr, ", ") + 
//                 " / " + 
//                 strictcount(string repr | repr = rep())}
// }

