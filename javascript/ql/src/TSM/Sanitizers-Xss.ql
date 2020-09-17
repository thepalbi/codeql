/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sanitizers

query predicate sanitizerXssClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof DomBasedXss::Sanitizer and q="DomBasedXss" or
        nd instanceof DomBasedXssWorse::Sanitizer and q="DomBasedXssWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}
