/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sourcePathClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof TaintedPath::Source and q="TaintedPath" or  
    nd instanceof  TaintedPathWorse::Source and q="TaintedPathWorse" 
    ) and  
    repr = PropagationGraph::getconcatrep(nd)
}
