/**
 * @kind graph
 */
import javascript
import TSM.PropagationGraphsAlt
import evaluation.DomBasedXssCustomizationsWorse
import semmle.javascript.security.dataflow.DomBasedXssCustomizations

// predicate sanitizerXssGuard(DataFlow::Node nd, string q, string repr){
//     (           
//         nd instanceof DomBasedXss::SanitizerGuard and q="DomBasedXss" or
//         nd instanceof DomBasedXssWorse::SanitizerGuard and q="DomBasedXssWorse"   
//     ) and
//     repr = PropagationGraph::getconcatrep(nd, false)
// }


// query predicate sanitizerXssClasses(DataFlow::Node nd, string q, string repr){
//     (           
//         nd instanceof DomBasedXss::Sanitizer and q="DomBasedXss" or
//         nd instanceof DomBasedXssWorse::Sanitizer and q="DomBasedXssWorse"       
//     ) and
//     repr = PropagationGraph::getconcatrep(nd, false)
//     or sanitizerXssGuard(nd, q, repr)
// }

// query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
//     (nd instanceof DomBasedXss::Source and q="DomBasedXss" or
//     nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
//     ) and    
//     repr = PropagationGraph::getconcatrep(nd, false)
// }

// query predicate sinkXssClasses(DataFlow::Node nd, string q, string repr){
//     (nd instanceof DomBasedXss::Sink and q="DomBasedXss" or
//     nd instanceof DomBasedXssWorse::Sink and q="DomBasedXssWorse"
//     ) and    
//     repr = PropagationGraph::getconcatrep(nd, false)
// }

predicate sanitizerXssGuard(DataFlow::Node nd, string q, string repr){
    nd instanceof DomBasedXssWorse::SanitizerGuard and q="DomBasedXssWorse"   
    and
    repr = PropagationGraph::getconcatrep(nd, false)
}


query predicate sanitizerXssClasses(DataFlow::Node nd, string q, string repr){
    nd instanceof DomBasedXssWorse::Sanitizer and q="DomBasedXssWorse"       
    and
    repr = PropagationGraph::getconcatrep(nd, false)
    or sanitizerXssGuard(nd, q, repr)
}

query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
    nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
    and    
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sinkXssClasses(DataFlow::Node nd, string q, string repr){
    nd instanceof DomBasedXssWorse::Sink and q="DomBasedXssWorse"
    and    
    repr = PropagationGraph::getconcatrep(nd, false)
}


