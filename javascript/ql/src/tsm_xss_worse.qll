import javascript

import NodeRepresentation


module TSMXssWorse{
    private import TsmRepr 

    string rep(DataFlow::Node node){
        result = candidateRep(node, _)
    }

    predicate isSink(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(getReprScore(rep(node), "snk"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSource(DataFlow::Node node, float score){
        exists(rep(node)) and   score = sum(getReprScore(rep(node), "src"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        exists(rep(node)) and
        score = sum(getReprScore(rep(node), "san"))/count(rep(node)) or
        not exists(rep(node)) and score = 0
    }

    float getReprScore(string repr, string t){
        TsmRepr::getReprScore(repr, t) or
   }    
}