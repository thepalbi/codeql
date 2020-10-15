import javascript

import TSM.NodeRepresentation
import tsm_repr_pred

module TSM {
    private import TsmRepr

    predicate isSourceCandidate(DataFlow::Node nd) {
          nd instanceof DataFlow::CallNode or
          nd instanceof DataFlow::PropRead or
          nd instanceof DataFlow::ParameterNode
      }
  
      predicate isSanitizerCandidate(DataFlow::Node nd) {
        nd instanceof DataFlow::CallNode
      }
  
      predicate isSinkCandidate(DataFlow::Node nd) {
        (
          exists(DataFlow::InvokeNode invk |
            nd = invk.getAnArgument()
            or
            nd = invk.(DataFlow::MethodCallNode).getReceiver()
          )
          or
          nd = any(DataFlow::PropWrite pw).getRhs()
        )
      }

    string rep(DataFlow::Node node){
        result = candidateRep(node, _)
    }

    predicate isSink(DataFlow::Node node, float score){
        isSinkCandidate(node) and
        (exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "snk"))/count(rep(node)) or
        not exists(rep(node)) and score = 0)
    }

    predicate isSource(DataFlow::Node node, float score){
        isSourceCandidate(node) and
        (exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "src"))/count(rep(node)) or
        not exists(rep(node)) and score = 0)
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        isSanitizerCandidate(node) and
        (exists(rep(node)) and
        score = sum(doGetReprScore(rep(node), "san"))/count(rep(node)) or
        not exists(rep(node)) and score = 0)
    }

    float doGetReprScore(string repr, string t){
        result = TsmRepr::getReprScore(repr, t)
   }    
}