/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sources
//import DomBasedXss
//import DomBasedXssWorse

query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Source and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}