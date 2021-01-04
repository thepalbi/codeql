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

predicate edgeFromDFNode(DataFlow::Node src, DataFlow::Node dest) {
  PropagationGraph::edge(PropagationGraph::fromDataFlowNode(src), PropagationGraph::fromDataFlowNode(dest))
}

predicate propagationGraphReachable(DataFlow::Node src, DataFlow::Node dest) {
  edgeFromDFNode(src, dest) or
  exists(DataFlow::Node mid | 
    edgeFromDFNode(src, mid) and propagationGraphReachable(mid, dest)
  )
}

from DataFlow::Node src, DataFlow::Node snk
where
  src instanceof RemoteFlowSource and
  snk instanceof FileSystemWriteAccessParameter and
  propagationGraphReachable(src, snk)
select src, snk