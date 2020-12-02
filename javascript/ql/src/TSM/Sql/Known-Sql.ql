/**
 * @kind graph
 */
import javascript
import TSM.TSM
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse

// Note from Diego: This predicate didn't exist in the old Sanitizers.ql
// I created this predidate following the template of other sanitizers
query predicate sanitizerSqlClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof SqlInjection::Sanitizer and q="SqlInjection" or
        nd instanceof SqlInjectionWorse::Sanitizer and q="SqlInjectionWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sourceSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof SqlInjection::Source and q="SqlInjection" or
    nd instanceof SqlInjectionWorse::Source and q="SqlInjectionWorse" 
    ) and   
    repr = PropagationGraph::getconcatrep(nd, false)
}
query predicate sinkSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof SqlInjection::Sink and q="SqlInjection" or
    nd instanceof SqlInjectionWorse::Sink and q="SqlInjectionWorse"
    ) and   
    repr = PropagationGraph::getconcatrep(nd, true)
}


