import javascript

import tsm.NodeRepresentation
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

    string rep(DataFlow::Node node, boolean rhs){
        // result = candidateRep(node, _, rhs)
        result = chooseBestRep(node, rhs)
    }

    predicate isSink(DataFlow::Node node, float score){
        isSinkCandidate(node) and
        (exists(rep(node, true)) and   score = sum(doGetReprScore(rep(node, true), "snk"))/count(rep(node, true)) or
        not exists(rep(node, true)) and score = 0)
    }

    predicate isSource(DataFlow::Node node, float score){
        isSourceCandidate(node) and
        (exists(rep(node, false)) and   score = sum(doGetReprScore(rep(node, false), "src"))/count(rep(node, false)) or
        not exists(rep(node, false)) and score = 0)
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        isSanitizerCandidate(node) and
        (exists(rep(node, false)) and
        score = sum(doGetReprScore(rep(node, false), "san"))/count(rep(node, false)) or
        not exists(rep(node, false)) and score = 0)
    }

    float doGetReprScore(string repr, string t){
        result = TsmRepr::getReprScore(repr, t)
   }    
}