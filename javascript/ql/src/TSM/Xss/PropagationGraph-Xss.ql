/**
 * @kind graph
 * @id javascript/propagation-graph
 */

import javascript
import TSM.PropagationGraphsAlt
import evaluation.DomBasedXssCustomizationsWorse
//import semmle.javascript.security.dataflow.DomBasedXssCustomizations

class XssSourceCandidate extends PropagationGraph::SourceCandidate {
  XssSourceCandidate() { isSourceWorse(this) } 
}

class XssSinkCandidate extends PropagationGraph::SinkCandidate {
  XssSinkCandidate() { none() } 
}


private string targetLibrary() { 
  // result = "jquery" 
  // or result = "angular"
  // or result = "XRegExp"
  // or result = "fs"
  exists(API::Node imp | 
      imp = API::moduleImport(result)
  )
}

predicate isSourceWorse(DataFlow::Node source) {
  source instanceof DomBasedXssWorse::Source
}

predicate isSinkWorse(DataFlow::Node sink) {
  sink instanceof DomBasedXssWorse::Sink
}

/**
 * Holds if there is a path from `src` through `san` to `snk` in the propagation graph,
 * which are source, sanitiser, and sink candidate, respectively.
 */
predicate triple(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk) {
  san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
  src != san and
  snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
  isCandidateSink(snk, targetLibrary()) and
  PropagationGraph::isSinkCandidate(_, snk)
}

query predicate pairSanSnk(string ssan, string ssnk){
  exists(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk |
      // isSourceWorse(src) and
      san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
      src.getEnclosingExpr() != san.getEnclosingExpr() and
      snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk, targetLibrary()) and
      PropagationGraph::isSinkCandidate(_, snk) and
      exists(PropagationGraph::getconcatrep(src, false)) and
      ssan = PropagationGraph::getconcatrep(san, false) and 
      ssnk = PropagationGraph::getconcatrep(snk, true)    
      )
}


query predicate pairSrcSan(string ssrc, string ssan){
  exists(DataFlow::Node src, DataFlow::Node san, DataFlow::Node snk |
    // isSourceWorse(src) and
    san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
    src.getEnclosingExpr() != san.getEnclosingExpr() and
    snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
    // We keep only sinks that are candidates
    // (parameters of library functions)
    isCandidateSink(snk, targetLibrary())  and
    PropagationGraph::isSinkCandidate(_, snk) and
    exists(PropagationGraph::getconcatrep(snk, true)) and  
    ssan = PropagationGraph::getconcatrep(san, false) and 
    ssrc = PropagationGraph::getconcatrep(src, false)  
    )
  }

  predicate testSink(string ssnk, DataFlow::Node snk) {
    exists(DataFlow::Node src, DataFlow::Node san |
      isSourceWorse(src) and
      san = PropagationGraph::reachableFromSourceCandidate(src, DataFlow::TypeTracker::end()) and
      src.getEnclosingExpr() != san.getEnclosingExpr() and
      snk = PropagationGraph::reachableFromSanitizerCandidate(san, DataFlow::TypeTracker::end()) and
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk, targetLibrary()) and
      PropagationGraph::isSinkCandidate(_, snk) and
      ssnk = PropagationGraph::getconcatrep(snk, true) 
      )
  }

query predicate eventToConcatRep(DataFlow::Node n, string repr){
  repr = PropagationGraph::getconcatrep(n, _)
}

predicate testMissing(DataFlow::Node u, string rep) {
  u instanceof DomBasedXssWorse::Source
  and not isSourceCandidate(_, u)  
  and rep = PropagationGraph::rep(u, false) 
}

predicate isSourceCandidate(API::Node nd, DataFlow::Node u) {
  // nd instanceof DataFlow::CallNode or
  // nd instanceof DataFlow::PropRead or
  // nd instanceof DataFlow::ParameterNode
  PropagationGraph::mayComeFromLibrary(nd) and
  not nd = API::moduleImport(_) and
  u = nd.getAnImmediateUse() and
  exists(PropagationGraph::rep(u, false)) and
  (
    not PropagationGraph::knownStep(_, u) and
    (
      u instanceof DataFlow::CallNode and
      not u = any(Import i).getImportedModuleNode()
      or
      u instanceof DataFlow::ParameterNode
    )
    or
    u instanceof DataFlow::PropRead
  )
  // or
  // u instanceof XssSourceCandidate
}
