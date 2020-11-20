/**
 * @name Unsafe shell command constructed from library input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @id js/shell-command-constructed-from-input
 */

import javascript
import TSM.PropagationGraphs

class CharacterizationConfiguration extends DataFlow::Configuration {
  CharacterizationConfiguration() { this = "Characterization" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node source) {
    source instanceof FileSystemWriteAccessParameter
  }
}

class FileSystemWriteAccessParameter extends DataFlow::Node {
  FileSystemWriteAccessParameter() {
    exists(FileSystemWriteAccess fswa | fswa.getAPathArgument() = this)
  }
}

predicate propagationGraphReachable(
  PropagationGraph::Node source, PropagationGraph::Node destination
) {
  // There's a direct floecho Hellow
  PropagationGraph::edge(source, destination)
  or
  // There's a flow through an intermediate node
  exists(PropagationGraph::Node intermediate |
    PropagationGraph::edge(source, intermediate) and
    propagationGraphReachable(intermediate, destination)
  )
}

query predicate allPropgraphNodes(PropagationGraph::Node nd, string concatRepr) {
  nd = nd and concatRepr = concat(nd.rep(), "::")
}

query predicate allPointsTo(PropagationGraph::Node frm, PropagationGraph::Node to, string reason) {
  PropagationGraph::pointsTo(_, frm.asDataFlowNode(), reason).(DataFlow::Node) = to.asDataFlowNode()
}

query predicate allAllocationSites(PropagationGraph::AllocationSite allocationSite) {
  allocationSite = allocationSite
}

query predicate reprTest(PropagationGraph::Node nd) {
  nd.rep() = "(parameter -1 *)"
}

from PropagationGraph::Node src, PropagationGraph::Node snk 
where 
  src.asDataFlowNode() instanceof RemoteFlowSource and
  snk.asDataFlowNode() instanceof FileSystemWriteAccessParameter and
  propagationGraphReachable(src, snk)
select src, "There's a flow-path from $@ to snk",src, snk, snk