/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sinks

query predicate sinkSelClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof Seldon::Sink and q="Seldon" or
    nd instanceof SeldonWorse::Sink and q="SeldonWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}
