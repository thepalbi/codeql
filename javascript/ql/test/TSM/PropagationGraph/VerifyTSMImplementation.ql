/**
 * @name Unsafe shell command constructed from library input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @id js/shell-command-constructed-from-input
 */

import javascript
import TSM.PropagationGraphs
import TSM.Characterization

predicate propagationGraphReachable(
  PropagationGraph::Node source, PropagationGraph::Node destination
) {
  PropagationGraph::edge(source, destination) or 
  exists(PropagationGraph::Node mid | 
    PropagationGraph::edge(source, mid) and propagationGraphReachable(mid, destination)
  )
}

from PropagationGraph::Node src, PropagationGraph::Node snk
where
  src.asDataFlowNode() instanceof RemoteFlowSource and
  snk.asDataFlowNode() instanceof FileSystemWriteAccessParameter and
  propagationGraphReachable(src, snk)
select src, snk