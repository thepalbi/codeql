/**
 * @kind graph
 */
import javascript
import PropagationGraphs
import Sources

query predicate sourceSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof SqlInjection::Source and q="SqlInjection" or  
    nd instanceof  SqlInjectionWorse::Source and q="SqlInjectionWorse" 
    ) and  
    repr = PropagationGraph::getconcatrep(nd)
}
