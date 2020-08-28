import javascript

import NodeRepresentation
import tsm_repr_pred

module TSMWorse {
    private import TsmRepr

    string rep(DataFlow::Node node){
        result = candidateRep(node, _)
    }

    predicate isSink(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "snk"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSource(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(doGetReprScore(rep(node), "src"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(doGetReprScore(rep(node), "san"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    float doGetReprScore(string repr, string t){
        result = TsmRepr::getReprScore(repr, t)
   }    
}