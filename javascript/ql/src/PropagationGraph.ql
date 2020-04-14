/**
 * @kind graph
 */

import javascript
import PropagationGraphs

/*
from PropagationGraph::Node pred, PropagationGraph::Node succ
where PropagationGraph::edge(pred, succ)
select pred, succ
*/

/* blows up but finishes */
query predicate representableEdge(PropagationGraph::Node pred, PropagationGraph::Node succ) {
       PropagationGraph::edge(pred, succ) and 
       (pred != succ) and
       (not pred.unrepresentable()) and
       (not succ.unrepresentable())
}
/* */

/* Takes forever
query predicate representableTriples(PropagationGraph::Node src, PropagationGraph::Node snk,  PropagationGraph::Node san) {
       representableEdge(src, snk) and
       representableEdge(snk, san) and
       src != san
}
*/

/* crashes even though we use edge and not edge+
from PropagationGraph::Node n1, PropagationGraph::Node n2
where (PropagationGraph::edge(n1, n2) and n1 != n2)
select "Src?(" + n1 + ") && San?(" + n2 + ") ==> " + concat (PropagationGraph::Node n3 | representableTriples(n1, n2, n3) | n3.toString(), " + ") + "is high"
*/