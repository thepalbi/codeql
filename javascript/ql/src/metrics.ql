import javascript
import PropagationGraphs
import metrics

predicate isPredictedSink(PropagationGraph::Node node, float score){
    node.isSinkCandidate() and 
    exists(node.rep()) and
    score = sum(ReprScores::getReprScore(node.rep(), "snk"))/count(node.rep()) and 
    score > 0.9   
}

predicate isPredictedSource(PropagationGraph::Node node, float score){
    node.isSourceCandidate() and 
    exists(node.rep()) and 
    score = sum(ReprScores::getReprScore(node.rep(), "src"))/count(node.rep()) and 
    score > 0.9
}

predicate isPredictedSanitizer(PropagationGraph::Node node, float score){
    node.isSanitizerCandidate() and 
    exists(node.rep()) and 
    score = sum(ReprScores::getReprScore(node.rep(), "san"))/count(node.rep()) and 
    score > 0.9
}

predicate isKnownSink(PropagationGraph::Node pnode){
    pnode.isSinkCandidate() and
    ReprScores::allSinks(pnode, pnode.asDataFlowNode())
}

predicate isKnownSource(PropagationGraph::Node pnode){
    pnode.isSourceCandidate() and
    ReprScores::allSources(pnode, pnode.asDataFlowNode())
}

predicate isKnownSanitizer(PropagationGraph::Node pnode){
    pnode.isSanitizerCandidate() and
    ReprScores::allSanitizers(pnode, pnode.asDataFlowNode())
}

predicate isKnownAndPredictedSink(PropagationGraph::Node node){
    isPredictedSink(node,_) and isKnownSink(node)    
}

// query predicate precision(PropagationGraph::Node node, float precision){
//     precision = count(isPredictedSink(node, _) and isKnownSink(node))/count(isPredictedSink(node, _))
// }
float getPrecisionSink(){
    result=(count(PropagationGraph::Node n | isKnownSink(n) and isPredictedSink(n, _)| n) + 0.0)/count(PropagationGraph::Node n| isPredictedSink(n, _) | n)
}

float getPrecisionSource(){
    result=(count(PropagationGraph::Node n | isKnownSource(n) and isPredictedSource(n, _)| n) + 0.0)/count(PropagationGraph::Node n| isPredictedSource(n, _) | n)
}

float getPrecisionSanitizer(){
    result=(count(PropagationGraph::Node n | isKnownSanitizer(n) and isPredictedSanitizer(n, _)| n) + 0.0)/count(PropagationGraph::Node n| isPredictedSanitizer(n, _) | n)
}

query predicate isKnownNotCandidateSink(PropagationGraph::Node node){
    ReprScores::allSinks(node, _) and 
    not node.isSinkCandidate()
}

query predicate isKnownNotCandidateSource(PropagationGraph::Node node){
    ReprScores::allSources(node, _) and 
    not node.isSourceCandidate()
}
