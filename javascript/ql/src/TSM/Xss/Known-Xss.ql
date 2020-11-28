/**
 * @kind graph
 */
import javascript
import TSM.PropagationGraphs
import semmle.javascript.security.dataflow.DomBasedXssCustomizationsWorse
import semmle.javascript.security.dataflow.DomBasedXssCustomizations

query predicate sanitizerXssClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof DomBasedXss::Sanitizer and q="DomBasedXss" or
        nd instanceof DomBasedXssWorse::Sanitizer and q="DomBasedXssWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Source and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sinkXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Sink and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Sink and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd, false)
}


