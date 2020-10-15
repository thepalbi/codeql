/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sinkSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof SqlInjection::Sink and q="SqlInjection" or
    nd instanceof SqlInjectionWorse::Sink and q="SqlInjectionWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}
