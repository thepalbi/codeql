/**
 * @kind graph
 */
import javascript
import TSM.TSM

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
    repr = PropagationGraph::getconcatrep(nd, true)
}