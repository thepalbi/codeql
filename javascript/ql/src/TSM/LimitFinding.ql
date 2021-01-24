import javascript
import TSM.PropagationGraphsAlt
import TSM.Characterization

predicate edgeFromDFNode(DataFlow::Node src, DataFlow::Node dest) {
    dest = PropagationGraph::reachableNode(src, DataFlow::TypeTracker::end())
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