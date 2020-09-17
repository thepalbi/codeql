import javascript

import NodeRepresentation

module TSMXssWorse{
    import tsm_worse
    string rep(DataFlow::Node node){
        result = TSMWorse::rep(node)
    }

    predicate isSink(DataFlow::Node node, float score){
        TSMWorse::isSink(node, score)
    }

    predicate isSource(DataFlow::Node node, float score){
        TSMWorse::isSource(node, score)
    }

    predicate isSanitizer(DataFlow::Node node, float score){
        TSMWorse::isSanitizer(node, score)
    }

    float doGetReprScore(string repr, string t){
        result = TSMWorse::doGetReprScore(repr, t)
   }    
}