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

query predicate sanitizerPathClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof TaintedPath::Sanitizer and q="TaintedPath" or
        nd instanceof TaintedPathWorse::Sanitizer and q="TaintedPathWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd, false)
}



