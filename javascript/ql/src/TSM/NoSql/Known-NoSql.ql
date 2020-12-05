/**
 * @kind graph
 */
import javascript
import TSM.PropagationGraphsAlt
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse

// Note from Diego: This predicate didn't exist in the old Sanitizers.ql
// I created this predidate following the template of other sanitizers
query predicate sanitizerNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof NosqlInjection::Sanitizer and q="NosqlInjection" or
        nd instanceof NosqlInjectionWorse::Sanitizer and q="NosqlInjectionWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sourceNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof NosqlInjection::Source and q="NosqlInjection" or
    nd instanceof NosqlInjectionWorse::Source and q="NosqlInjectionWorse" 
    ) and   
    repr = PropagationGraph::getconcatrep(nd, false)
}
query predicate sinkNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof NosqlInjection::Sink and q="NosqlInjection" or
    nd instanceof NosqlInjectionWorse::Sink and q="NosqlInjectionWorse"
    ) and   
    repr = PropagationGraph::getconcatrep(nd, true)
}


