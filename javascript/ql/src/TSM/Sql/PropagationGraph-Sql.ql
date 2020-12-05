/**
 * @kind graph
 * @id javascript/propagation-graph
 */

import javascript
import TSM.PropagationGraphsAlt
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse

private string targetLibrary() { 
  result in ["sql", "sql.js", "sqlstring", "mssql", "mysql", 
            "sequelize", "sqlite3", "better-sqlite3", 
            "knex", "postgres", "oracledb",
            "tedious", "pretty-data", "db-migrate"] 
  // exists(API::Node imp | 
  //     imp = API::moduleImport(result)
  // )
}

predicate isSourceWorse(DataFlow::Node source) {
  source instanceof SqlInjectionWorse::Source
}


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

