import javascript
import PropagationGraphs
import metrics
import CommandInjection
import NodeRepresentation

predicate isSource(PropagationGraph::Node n){
    n.isSourceCandidate()
}

predicate isStep(PropagationGraph::Node n1, PropagationGraph::Node n2){
    PropagationGraph::edge(n1, n2)
}

predicate shortestPathLength(PropagationGraph::Node n1, PropagationGraph::Node n2, int length) =
   shortestDistances(isSource/1, isStep/2)(n1, n2, length)

predicate getEdgeLength(PropagationGraph::Node n1, PropagationGraph::Node n2, int length){  
    n2.isSinkCandidate() and
    shortestPathLength(n1, n2, length)
}

predicate getEdgeStats(int maxPathLength, float avgPathLength){
    maxPathLength = max(int l | exists(PropagationGraph::Node n1, PropagationGraph::Node n2 | getEdgeLength(n1, n2, l)) and l > 0) and
    avgPathLength = avg(int l | exists(PropagationGraph::Node n1, PropagationGraph::Node n2 | getEdgeLength(n1, n2, l)) and l > 0) 
}

/*
predicate noReps(DataFlow::Node node){
    node instanceof SqlInjection::Sink and
    not node instanceof SqlInjectionWorse::Sink  and
    //not exists (PropagationGraph::Node n | n.asDataFlowNode() = node) and
    not exists(candidateRep(node, _))
}
*/
