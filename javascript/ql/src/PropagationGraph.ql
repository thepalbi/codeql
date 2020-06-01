/**
 * @kind graph
 */

import javascript
import PropagationGraphs

predicate reachableFromSourceCandidate(PropagationGraph::Node src, PropagationGraph::Node nd) {
  src.isSourceCandidate() and
  PropagationGraph::edge(src, nd)
  or
  exists(PropagationGraph::Node mid |
    reachableFromSourceCandidate(src, mid) and 
    PropagationGraph::edge(mid, nd)
  )
}

predicate reachableFromSanitizerCandidate(PropagationGraph::Node san, PropagationGraph::Node nd) {
  san.isSanitizerCandidate() and
  PropagationGraph::edge(san, nd)
  or
  exists(PropagationGraph::Node mid |
    reachableFromSanitizerCandidate(san, mid) and
    PropagationGraph::edge(mid, nd)
  )
}

// print the set of connected triples
query predicate triple(PropagationGraph::Node src, PropagationGraph::Node san, PropagationGraph::Node snk) {
  reachableFromSourceCandidate(src, san) and
  san.isSanitizerCandidate() and
  src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
  reachableFromSanitizerCandidate(san, snk) and
  snk.isSinkCandidate()
  // NB: we do not require `san` and `snk` to be different, since we might have a situation like
  // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
}

query predicate tripleWAtleastOneRep(NodeWithFewReps src, NodeWithFewReps san, NodeWithFewReps snk) {
  reachableFromSourceCandidate(src, san) and
  san.isSanitizerCandidate() and
  src.asDataFlowNode().getEnclosingExpr() != san.asDataFlowNode().getEnclosingExpr() and
  reachableFromSanitizerCandidate(san, snk) and
  snk.isSinkCandidate()
  // NB: we do not require `san` and `snk` to be different, since we might have a situation like
  // `sink(sanitize(src))` where `san` and `snk` are both `sanitize(src)`
}

// prints 1 representation of event
query predicate eventToRep(PropagationGraph::Node node, string str)
{ 
  str = node.rep()
}

class NodeWithFewReps extends PropagationGraph::Node {
  NodeWithFewReps() { strictcount(rep()) <= 10000 and strictcount(rep()) > 0}
  
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

/*
query predicate seldonConstraint1(
  PropagationGraph::Node src, PropagationGraph::Node san, int snkCount
 ) {
  snkCount = strictcount(PropagationGraph::Node snk | triple(src, san, snk))
 }

query predicate seldonConstraint2(
  PropagationGraph::Node san, PropagationGraph::Node snk, int srcCount
 ) {
  srcCount = strictcount(PropagationGraph::Node src | triple(src, san, snk))
 }

query predicate seldonConstraint3(
  PropagationGraph::Node src, PropagationGraph::Node snk, int sanCount
 ) {
  sanCount = strictcount(PropagationGraph::Node san | triple(src, san, snk))
 }
 */

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

