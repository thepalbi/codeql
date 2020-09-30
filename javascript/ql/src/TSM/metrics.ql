import javascript
import metrics
import tsm_worse
import PropagationGraphs

//import scores_nosqlinjection


query predicate stats(int loc, int functions, int files, int sourceCandidates, int sinkCandidates, int sanitizerCandidates){    
    loc = sum(File f | | f.getNumberOfLinesOfCode())
    and 
    files = count(File f | f.getExtension() = "ts" or f.getExtension() = "js") 
    and
    functions = count(Function f) 
    and
    sourceCandidates = count(PropagationGraph::Node node| node.isSourceCandidate())
    and
    sinkCandidates = count(PropagationGraph::Node node| node.isSinkCandidate()) 
    and
    sanitizerCandidates = count(PropagationGraph::Node node | node.isSanitizerCandidate())

}

// predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     node = pnode.asDataFlowNode() 
//     and 
//     exists(pnode.rep())
//     and
//     score = sum(TSMWorse::doGetReprScore(pnode.rep(), "san"))/count(pnode.rep())
//     and 
//     ((isKnown = true and isKnownSanitizer(pnode)) or (isKnown = false and not isKnownSanitizer(pnode))) 
//     and
//     ((pnode.isSanitizerCandidate() and isCandidate = true )
//     or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
//     and
//     type = "call"
//     and
//     crep = pnode.getconcatrep()   
// }

// predicate predictionsSource(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     node = pnode.asDataFlowNode() 
//     and 
//     exists(pnode.rep())
//     and
//     score = sum(TSMWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
//     and 
//     ((isKnown = true and isKnownSource(pnode)) or (isKnown = false and not isKnownSource(pnode))) 
//     and
//     ((pnode.isSourceCandidate() and getSrcType(node) = type and isCandidate = true )
//     or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
//     and
//     crep = pnode.getconcatrep()
// }

// predicate predictionsSink(DataFlow::Node node, PropagationGraph::Node pnode, 
//     float score, boolean isKnown, boolean isCandidate, string type, string crep){
//     node = pnode.asDataFlowNode() 
//     and 
//     exists(pnode.rep())
//     and
//     score = sum(TSMWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
//     and 
//     ((isKnown = true and isKnownSink(pnode)) or (isKnown = false and not isKnownSink(pnode))) 
//     and
//     ((pnode.isSinkCandidate() and getSrcType(node) = type and isCandidate = true )
//     or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
//     and
//     crep = pnode.getconcatrep()
// }

string getSinkType(DataFlow::Node node){    
    (exists(DataFlow::InvokeNode invk |
        (node = invk.getAnArgument() and  result = "argument")
        or
        (node = invk.(DataFlow::MethodCallNode).getReceiver() and result = "call")
      )
      or
      (node = any(DataFlow::PropWrite pw).getRhs()) and result = "propwrite")   
      
}

string getSrcType(DataFlow::Node nd){
    nd instanceof DataFlow::CallNode and result = "call" or
    nd instanceof DataFlow::PropRead  and result = "propread" or
    nd instanceof DataFlow::ParameterNode and result = "parameter"
}

predicate isPredictedSink(PropagationGraph::Node node, float score){    
    exists(node.rep()) and
    score = sum(ReprScores::getReprScore(node.rep(), "snk"))/count(node.rep())
}

predicate isPredictedSource(PropagationGraph::Node node, float score){    
    exists(node.rep()) and 
    score = sum(ReprScores::getReprScore(node.rep(), "src"))/count(node.rep())
}

predicate isPredictedSanitizer(PropagationGraph::Node node, float score){    
    exists(node.rep()) and 
    score = sum(ReprScores::getReprScore(node.rep(), "san"))/count(node.rep())
}

predicate isNewRepr(string r){
    exists(PropagationGraph::Node n| n.isSourceCandidate() and 
    r = n.rep() and 
    ReprScores::getReprScore(r, "src") > 0 
    and not isKnownRepr(r)
    )
}

predicate isKnownRepr(string r){
    exists(PropagationGraph::Node p | isKnownSource(p) and r = p.rep())
}

predicate isKnownSink(PropagationGraph::Node pnode){    
    Metrics::allSinks(pnode, pnode.asDataFlowNode())
}

predicate isKnownSource(PropagationGraph::Node pnode){    
    Metrics::allSources(pnode, pnode.asDataFlowNode())
}

predicate isKnownSanitizer(PropagationGraph::Node pnode){
    pnode.isSanitizerCandidate() and
    Metrics::allSanitizers(pnode, pnode.asDataFlowNode())
}

predicate isKnownAndPredictedSink(PropagationGraph::Node node){
    isPredictedSink(node,_) and isKnownSink(node)    
}

predicate isKnownNotCandidateSink(PropagationGraph::Node node){
    exists(node.rep()) and
    Metrics::allSinks(node, _) and 
    not node.isSinkCandidate()
}

predicate isKnownNotCandidateSource(PropagationGraph::Node node){
    exists(node.rep()) and
    Metrics::allSources(node, _) and 
    not node.isSourceCandidate()
}
