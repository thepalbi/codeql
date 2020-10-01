import javascript
import PropagationGraphs
import metrics

predicate isSource(PropagationGraph::Node n){
    n.isSourceCandidate()
}
