/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sinkSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof TaintedPath::Sink and q="TaintedPath" or
    nd instanceof TaintedPathWorse::Sink and q="TaintedPathWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}
