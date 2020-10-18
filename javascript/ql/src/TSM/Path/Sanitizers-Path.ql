/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sanitizerPathClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof TaintedPath::Sanitizer and q="TaintedPath" or
        nd instanceof TaintedPathWorse::Sanitizer and q="TaintedPathWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}
