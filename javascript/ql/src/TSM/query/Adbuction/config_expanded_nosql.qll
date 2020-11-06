/**
 * Provides a taint tracking configuration for reasoning about Seldon's paper example 
 *
 */

import javascript
import TSM.NodeRepresentation

module ExpandedConfiguration {
  import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
//  import semmle.javascript.security.dataflow.NosqlInjectionCustomizations

  private string targetLibrary() { 
    result = "mongoose" 
    or result = "mongodb"
  }

  predicate test(DataFlow::InvokeNode invk) {
    callFromImport(targetLibrary(), invk)
  }

  private predicate callFromImport(string library, DataFlow::InvokeNode invk) {
    invk = API::moduleImport(library).getASuccessor*().getAnInvocation()
    // DataFlow::moduleImport(library).getACall()=call 
    // or callFromAllocFromImport(library, call)
    // or callFromReceiverFromImport(library, _, call)
    // or call.hasUnderlyingType(library, _)
  }

  // private predicate callFromAllocFromImport(string library, DataFlow::CallNode call) {
  //     call = DataFlow::moduleImport(library)
  //           .getAnInstantiation().getAPropertyRead().getACall()
    
  // }

  // private predicate callFromReceiverFromImport(string library, 
  //                                             string member, 
  //                                             DataFlow::CallNode call) {
  //   call = DataFlow::moduleImport(library).getAChainedMethodCall(member)
  //   //call = DataFlow::moduleMember(library,member).getACall() 
  //   // and library = "express"
  // }



private predicate isCallBackArgument(DataFlow::Node callBack, DataFlow::InvokeNode invk) {
  callBack = invk.getABoundCallbackParameter(_,_)
}

  // private predicate callFromImport(string library, DataFlow::InvokeNode call) {
  //   DataFlow::moduleImport(library).getACall().(DataFlow::InvokeNode)=call
  // }

  // private predicate isCallBackArgument(DataFlow::Node callBack, DataFlow::InvokeNode invk) {
  //   callBack = invk.getABoundCallbackParameter(_,_)
  //   // callBack = invk.getAnArgument() and
  //   // exists (DataFlow::FunctionNode f |
  //   //     f.flowsToExpr(callBack.asExpr())
  //   //   ) 
  // }

  predicate isCandidateSource(DataFlow::Node source) {
    exists (DataFlow::InvokeNode call, DataFlow::Node callback  |
      isRelevant(call) and callFromImport(targetLibrary(), call) and
      isCallBackArgument(callback, call) and source = callback
    )
  }
  
  predicate isCandidateSink(DataFlow::Node sink) { 
    exists (DataFlow::InvokeNode call, DataFlow::Node arg  |
    isRelevant(call) and callFromImport(targetLibrary(), call) and
    (arg = call.getAnArgument() or arg = call.(DataFlow::CallNode).getReceiver())
    and not (isCallBackArgument(arg, call)) and
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

  /**
   * A taint-tracking configuration for reasoning about NoSQL-injection vulnerabilities.
   */
  class ExpandedConfiguration extends TaintTracking::Configuration {
    ExpandedConfiguration() { this = "ExpandedConfiguration" }

    override predicate isSource(DataFlow::Node source) { 
      // isCandidateSource(source) 
      // or 
      source instanceof NosqlInjectionWorse::Source 
    }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      TaintedObject::isSource(source, label)
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      isCandidateSink(sink) 
      or 
      sink.(NosqlInjectionWorse::Sink).getAFlowLabel() = label
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof NosqlInjectionWorse::Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof TaintedObject::SanitizerGuard
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      TaintedObject::step(src, trg, inlbl, outlbl)
      or
      // additional flow step to track taint through NoSQL query objects
      inlbl = TaintedObject::label() and
      outlbl = TaintedObject::label() and
      exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
        queryObj.flowsToExpr(query) and
        queryObj.flowsTo(trg) and
        src = queryObj.getAPropertyWrite().getRhs()
      )
    }
  }
}
