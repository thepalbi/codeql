/**
 * @kind graph
 */
import javascript
import TSM.TSM
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

// Note from Diego: This predicate didn't exist in the old Sanitizers.ql
// I created this predidate following the template of other sanitizers
query predicate sanitizerNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof NosqlInjection::Sanitizer and q="NosqlInjection" or
        nd instanceof NosqlInjectionWorse::Sanitizer and q="NosqlInjectionWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}

