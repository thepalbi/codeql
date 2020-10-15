/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Source and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}