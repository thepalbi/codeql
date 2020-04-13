/**
 * @kind graph
 */

import javascript
import PropagationGraphs

from PropagationGraph::Node pred, PropagationGraph::Node succ
where PropagationGraph::edge(pred, succ)
select pred, succ