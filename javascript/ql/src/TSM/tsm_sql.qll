
import javascript

import NodeRepresentation

module TSMSql{
    import tsm
    string rep(DataFlow::Node node){
        result = TSM::rep(node)
    }

    predicate isSink(DataFlow::Node node, float score){
        TSM::isSink(node, score) 
    }

    predicate isSource(DataFlow::Node node, float score){
        TSM::isSource(node, score)
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        TSM::isSanitizer(node, score)
    }

    float doGetReprScore(string repr, string t){
        result = TSM::doGetReprScore(repr, t)
   }    
}