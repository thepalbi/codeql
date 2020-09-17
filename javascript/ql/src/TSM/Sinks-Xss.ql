/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sinks

query predicate sinkXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Sink and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Sink and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}
