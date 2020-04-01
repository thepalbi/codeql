/**
 * @kind graph
 */

import javascript
import PropagationGraphs

query predicate edges(DataFlow::Node pred, DataFlow::Node succ) {
  PropagationGraph::edge(pred, succ)
}
