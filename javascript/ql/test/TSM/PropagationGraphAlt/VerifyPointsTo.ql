/**
 * @name Unsafe shell command constructed from library input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @id js/shell-command-constructed-from-input
 */

import javascript
import TSM.PropagationGraphs
import PropagationGraphAlt

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
  reachableNode(source.asDataFlowNode(), DataFlow::TypeTracker::end()) = destination.asDataFlowNode()
}

from PropagationGraph::Node src, PropagationGraph::Node snk
where
  src.asDataFlowNode() instanceof RemoteFlowSource and
  snk.asDataFlowNode() instanceof FileSystemWriteAccessParameter and
  propagationGraphReachable(src, snk)
select src, snk