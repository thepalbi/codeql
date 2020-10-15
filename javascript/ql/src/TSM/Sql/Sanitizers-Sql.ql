/**
 * @kind graph
 */
import javascript
import TSM.TSM

query predicate sanitizerSqlClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof SqlInjection::Sanitizer and q="SqlInjection" or
        nd instanceof SqlInjectionWorse::Sanitizer and q="SqlInjectionWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}
