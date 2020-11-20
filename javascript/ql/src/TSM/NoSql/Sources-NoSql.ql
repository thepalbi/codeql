/**
 * @kind graph
 */
import javascript
import TSM.TSM

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
    repr = PropagationGraph::getconcatrep(nd, false)
}
