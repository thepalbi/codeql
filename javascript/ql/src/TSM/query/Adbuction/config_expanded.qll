/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import TSM.NodeRepresentation

module ExpandedConfiguration {
  import semmle.javascript.security.dataflow.TaintedPath::TaintedPath
  
  private predicate callFromImport(string library, DataFlow::InvokeNode call) {
    DataFlow::moduleImport(library).getACall().(DataFlow::InvokeNode)=call
  }

  private predicate isCallBackArgument(DataFlow::Node callBack, DataFlow::InvokeNode invk) {
    callBack = invk.getABoundCallbackParameter(_,_)
    // callBack = invk.getAnArgument() and
    // exists (DataFlow::FunctionNode f |
    //     f.flowsToExpr(callBack.asExpr())
    //   ) 
  }

  predicate isCandidateSource(DataFlow::Node source) {
    exists (DataFlow::InvokeNode call, DataFlow::Node callback  |
      isRelevant(call) and callFromImport("mv", call) and
      isCallBackArgument(callback, call) and source = callback
    )
  }
  
  predicate isCandidateSink(DataFlow::Node sink) { 
    exists (DataFlow::InvokeNode call, DataFlow::Node arg  |
    isRelevant(call) and callFromImport("mv", call) and
    arg = call.getAnArgument() and not (isCallBackArgument(arg, call)) and
    sink = arg  
    )
  }

  // class CandidateSink extends Sink 
  // {
  //   CandidateSink() { isCandidateSink(this)}
  // }

  // class CandidateSource extends Sink 
  // {
  //   CandidateSource() { isCandidateSource(this)}
  // }

  class ExpandedConfiguration extends DataFlow::Configuration { 
    // A tainted path config
    Configuration config; 

    ExpandedConfiguration() { this = "ExpandedConfiguration" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      config.isSource(source, label)
      or isCandidateSource(source) // and label = source.(Source).getAFlowLabel())
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      config.isSink(sink, label)
      or isCandidateSink(sink) // and label = sink.(Sink).getAFlowLabel())
    }

    override predicate isBarrier(DataFlow::Node node) {
      config.isBarrier(node)
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      config.isBarrierGuard(guard)
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      config.isAdditionalFlowStep(src, dst, srclabel, dstlabel)
    }
  }
}
