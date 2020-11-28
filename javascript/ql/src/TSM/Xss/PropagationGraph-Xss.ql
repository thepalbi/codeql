/**
 * @kind graph
 * @id javascript/propagation-graph
 */

import javascript
import TSM.PropagationGraphs
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse

private string targetLibrary() { 
  result = "jquey" 
  or result = "angular"
  or result = "XRegExp"
  // exists(API::Node imp | 
  //     imp = API::moduleImport(result)
  // )
}


predicate reachableFromSourceCandidate(
  PropagationGraph::SourceCandidate src, PropagationGraph::Node nd
) {
  PropagationGraph::edge(src, nd)
  or
  exists(PropagationGraph::Node mid |
    reachableFromSourceCandidate(src, mid) and 
    PropagationGraph::edge(mid, nd)
  )
}

predicate reachableFromSanitizerCandidate(
  PropagationGraph::SanitizerCandidate san, PropagationGraph::Node nd
) {
  PropagationGraph::edge(san, nd)
  or
  exists(PropagationGraph::Node mid |
    reachableFromSanitizerCandidate(san, mid) and
    PropagationGraph::edge(mid, nd)
  )
}

// print the set of connected triples
predicate triple(
  PropagationGraph::SourceCandidate src, PropagationGraph::SanitizerCandidate san, 
  PropagationGraph::SinkCandidate snk) {
  src.asDataFlowNode() instanceof DomBasedXssWorse::Source and
  reachableFromSourceCandidate(src, san) and
  src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
  isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
  reachableFromSanitizerCandidate(san, snk) 
  //snk.isSinkCandidate()  
  // NB: we do not require `san` and `snk` to be different, since we might have a situation like
  // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
}

predicate tripleWAtleastOneRep(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk) {
  reachableFromSourceCandidate(src, san) and
  san.isSanitizerCandidate() and
  src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
  reachableFromSanitizerCandidate(san, snk) and
  snk.isSinkCandidate()
  // NB: we do not require `san` and `snk` to be different, since we might have a situation like
  // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
}

predicate tripleWRepID(string ssrc, string ssan, string ssnk) {
    exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
    reachableFromSourceCandidate(src, san) and
    san.isSanitizerCandidate() and
    src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
    reachableFromSanitizerCandidate(san, snk) and
    snk.isSinkCandidate() and     
    ssrc = src.getconcatrep() and 
    ssan = san.getconcatrep() and 
    ssnk = snk.getconcatrep()
    )
    // NB: we do not require `san` and `snk` to be different, since we might have a situation like
    // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
}

query predicate allCalls(PropagationGraph::Node callNode, int lineNumber, string repr) {
  callNode = callNode and
  callNode.asDataFlowNode().getStartLine() = lineNumber 
  and repr = concat(callNode.rep(),"::")
}

query predicate pairSanSnk(string ssan, string ssnk){
  exists(PropagationGraph::SourceCandidate src, 
      PropagationGraph::SanitizerCandidate san, 
      PropagationGraph::SinkCandidate snk |
      src.asDataFlowNode() instanceof DomBasedXssWorse::Source and
      reachableFromSourceCandidate(src, san) and
      src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
      reachableFromSanitizerCandidate(san, snk) and
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
      ssan = san.getconcatrep(false) and 
      ssnk = snk.getconcatrep(true)    
      )
}


query predicate pairSrcSan(string ssrc, string ssan){
  exists(PropagationGraph::SourceCandidate src, 
    PropagationGraph::SanitizerCandidate san, 
    PropagationGraph::SinkCandidate snk |
    src.asDataFlowNode() instanceof DomBasedXssWorse::Source and
    reachableFromSourceCandidate(src, san) and
    src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
    reachableFromSanitizerCandidate(san, snk) and
    // We keep only sinks that are candidates
    // (parameters of library functions)
    isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
    ssan = san.getconcatrep(false) and 
    ssrc = src.getconcatrep(false)  
    )
  }



predicate pairSrcSanFew(string ssrc, string ssan){
  exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
    src.asDataFlowNode() instanceof DomBasedXssWorse::Source and
      reachableFromSourceCandidate(src, san) and
      san.isSanitizerCandidate() and
      src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
      reachableFromSanitizerCandidate(san, snk) and
      snk.isSinkCandidate() and 
      // We keep only sinks that are candidates
      // (parameters of library functions)
      isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
      ssrc = src.getconcatrep(false) and 
      ssan = san.getconcatrep(false)  
      //ssnk = snk.getconcatrep()    
      //ssrc = getconcatrep(src) and 
      //ssan = getconcatrep(san) 
      )
}

predicate pairSanSnkFew(string ssan, string ssnk){
    exists(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk |
      src.asDataFlowNode() instanceof DomBasedXssWorse::Source and
      reachableFromSourceCandidate(src, san) and
        san.isSanitizerCandidate() and
        src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
        reachableFromSanitizerCandidate(san, snk) and
        snk.isSinkCandidate() and         
        // We keep only sinks that are candidates
        // (parameters of library functions)
        isCandidateSink(snk.asDataFlowNode(), targetLibrary()) and
        ssan = san.getconcatrep(false) and 
        ssnk = snk.getconcatrep(true)    
        )
}

predicate tripleWEventType(string ssrc, string ssan, string ssnk) {
    exists(PropagationGraph::Node src, PropagationGraph::Node san, PropagationGraph::Node snk |
    triple(src, san, snk) and
    ssrc = src.getId() and
    ssan = san.getId() and
    ssnk = snk.getId()
    )
}



query predicate eventToConcatRep(PropagationGraph::Node n, string repr){
    repr = n.getconcatrep()
}

predicate dfnodeToRep(string r){
    exists(PropagationGraph::Node n | r = n.rep())
}

// prints 1 representation of event
 predicate eventToRep(PropagationGraph::Node node, string str)
{ 
  str = node.rep()
}

 predicate eventToRepUF(PropagationGraph::Node node, string str){
  str = node.rep1()
}

string getString(DataFlow::Node node){
    result = node.getFile().getAbsolutePath() + ":" + node.getStartLine() + ":" + node.getStartColumn() + ":"+ node.getEndLine() + ":" + node.getEndColumn()

}

string getconcatrep(PropagationGraph::Node node){
    result = strictconcat(string r | r = node.rep() | r, "::")
}

predicate commonDataFlowNode(PropagationGraph::Node node1, PropagationGraph::Node node2, DataFlow::Node dfnode1,
    DataFlow::Node dfnode2, string loc1, string loc2, string rep1, string rep2)
{
    dfnode1 = node1.asDataFlowNode() and dfnode2 = node2.asDataFlowNode() and
    dfnode1 != dfnode2 and     
    loc1 = getString(dfnode1) and loc2 = getString(dfnode2) and
    loc1 =  loc2 and 
    rep1 = getconcatrep(node1) and
    rep2 = getconcatrep(node2) 
}

class NodeWithFewReps extends PropagationGraph::Node {
  NodeWithFewReps() { strictcount(rep()) >= 1 }
  
  string toStr() {
    result = strictconcat(string repr | repr = rep() | repr, ", ") + 
                " / " + 
                strictcount(string repr | repr = rep())}
}


predicate seldonConstraint1AsString(
    NodeWithFewReps src,  
    NodeWithFewReps san, 
    string snkConstraint
) {
              snkConstraint = strictconcat(string repr | 
                     (exists (NodeWithFewReps snk | triple(src, san, snk) and repr = snk.toStr()))
                     | repr, " ++  ")
}

predicate seldonConstraint1Nolinks(
    string srcExpr,  
    string sanExpr, 
    string snkConstraint
) {
    exists (NodeWithFewReps src, NodeWithFewReps san | 
              srcExpr = src.toStr() and
              sanExpr = san.toStr() and
              snkConstraint = strictconcat(string repr | 
                     (exists (NodeWithFewReps snk | triple(src, san, snk) and repr = snk.toStr()))
                     | repr, " ++  ")
    )
}

predicate seldonConstraint2AsString(
    NodeWithFewReps src,  
    NodeWithFewReps snk, 
    string sanConstraint
) {
              sanConstraint = strictconcat(string repr | 
                     (exists (NodeWithFewReps san | triple(src, san, snk) and repr = san.toStr()))
                     | repr, " ++  ")
}

predicate seldonConstraint3AsString(
    NodeWithFewReps san,  
    NodeWithFewReps snk, 
    string srcConstraint
) {
              srcConstraint = strictconcat(string repr | 
                     (exists (NodeWithFewReps src | triple(src, san, snk) and repr = src.toStr()))
                     | repr, " ++  ")
}

predicate countoftypes(string type, int nodecnt, int repcnt) {
  type = "Source"  
  and nodecnt = count(PropagationGraph::Node nd | nd.isSourceCandidate()) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSourceCandidate() and rep = nd.rep())) or
  type = "Source.PropRead"  
  and nodecnt = count(PropagationGraph::Node nd | nd.isSourceCandidate() and nd.asDataFlowNode() instanceof DataFlow::PropRead) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSourceCandidate() and nd.asDataFlowNode() instanceof DataFlow::PropRead and rep = nd.rep())) or
  type = "Source.ParameterNode"  
  and nodecnt = count(PropagationGraph::Node nd | nd.isSourceCandidate() and nd.asDataFlowNode() instanceof DataFlow::ParameterNode) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSourceCandidate() and nd.asDataFlowNode() instanceof DataFlow::ParameterNode and rep = nd.rep())) or
  type = "Sanitizer" 
  and nodecnt = count(PropagationGraph::Node nd | nd.isSanitizerCandidate()) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSanitizerCandidate() and rep=nd.rep())) or
  type = "Sanitizer.Callsonly" 
  and nodecnt = count(PropagationGraph::Node nd | nd.isSanitizerCandidate() and nd.asDataFlowNode() instanceof DataFlow::CallNode) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSanitizerCandidate() and nd.asDataFlowNode() instanceof DataFlow::CallNode and rep=nd.rep())) or
  type = "Sink" 
  and nodecnt = count(PropagationGraph::Node nd | nd.isSinkCandidate()) 
  and repcnt = count(string rep | exists(PropagationGraph::Node nd | nd.isSinkCandidate() and rep=nd.rep()))
}

