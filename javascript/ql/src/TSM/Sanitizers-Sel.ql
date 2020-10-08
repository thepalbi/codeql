/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sanitizers

query predicate sanitizerSelClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof Seldon::Sanitizer and q="Seldon" or
        nd instanceof SeldonWorse::Sanitizer and q="SeldonWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}
