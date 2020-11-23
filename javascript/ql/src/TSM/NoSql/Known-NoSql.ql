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

query predicate sourceNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof NosqlInjection::Source and q="NosqlInjection" or
    nd instanceof NosqlInjection1::Source and q="NosqlInjection1" or
    nd instanceof NosqlInjection2::Source and q="NosqlInjection2" or
    nd instanceof NosqlInjection3::Source and q="NosqlInjection3" or
    nd instanceof NosqlInjection4::Source and q="NosqlInjection4" or
    nd instanceof NosqlInjection5::Source and q="NosqlInjection5" or 
    nd instanceof NosqlInjection6::Source and q="NosqlInjection6" or
    nd instanceof NosqlInjectionWorse::Source and q="NosqlInjectionWorse" 
    ) and   
    repr = PropagationGraph::getconcatrep(nd)
}
query predicate sinkNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof NosqlInjection::Sink and q="NosqlInjection" or
    nd instanceof NosqlInjection1::Sink and q="NosqlInjection1" or
    nd instanceof NosqlInjection2::Sink and q="NosqlInjection2" or
    nd instanceof NosqlInjection3::Sink and q="NosqlInjection3" or
    nd instanceof NosqlInjection4::Sink and q="NosqlInjection4" or
    nd instanceof NosqlInjection5::Sink and q="NosqlInjection5" or 
    nd instanceof NosqlInjection6::Sink and q="NosqlInjection6" or
    nd instanceof NosqlInjectionWorse::Sink and q="NosqlInjectionWorse"
    ) and   
    repr = PropagationGraph::getconcatrep(nd)
}


