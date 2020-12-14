/**
 * @kind graph
 */
import javascript
import TSM.PropagationGraphsAlt
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import semmle.javascript.security.dataflow.TaintedPathCustomizationsWorse

query predicate sourcePathClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof TaintedPath::Source and q="TaintedPath" or  
    nd instanceof  TaintedPathWorse::Source and q="TaintedPathWorse" 
    ) and  
    repr = PropagationGraph::getconcatrep(nd, false)
}

query predicate sinkPathClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof TaintedPath::Sink and q="TaintedPath" or
    nd instanceof TaintedPathWorse::Sink and q="TaintedPathWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd, true)
}

predicate sanitizerPathGuard(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof TaintedPath::BarrierGuardNode and q="TaintedPath" or
        nd instanceof TaintedPathWorse::BarrierGuardNode and q="TaintedPathWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}


query predicate sanitizerPathClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof TaintedPath::Sanitizer and q="TaintedPath" or
        nd instanceof TaintedPathWorse::Sanitizer and q="TaintedPathWorse" or
        sanitizerPathGuard(nd, q, repr)    
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}



