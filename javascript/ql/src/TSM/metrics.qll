import javascript
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithmCustomizations
import semmle.javascript.security.dataflow.CleartextLoggingCustomizations
import semmle.javascript.security.dataflow.CleartextStorageCustomizations
import semmle.javascript.security.dataflow.ClientSideUrlRedirectCustomizations
import semmle.javascript.security.dataflow.CodeInjectionCustomizations
import semmle.javascript.security.dataflow.CommandInjectionCustomizations
import semmle.javascript.security.dataflow.ConditionalBypassCustomizations
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsCustomizations
import semmle.javascript.security.dataflow.DifferentKindsComparisonBypassCustomizations
import semmle.javascript.security.dataflow.FileAccessToHttpCustomizations
import semmle.javascript.security.dataflow.HardcodedCredentialsCustomizations
import semmle.javascript.security.dataflow.HardcodedDataInterpretedAsCodeCustomizations
import semmle.javascript.security.dataflow.HttpToFileAccessCustomizations
import semmle.javascript.security.dataflow.IndirectCommandInjectionCustomizations
import semmle.javascript.security.dataflow.InsecureRandomnessCustomizations
import semmle.javascript.security.dataflow.InsufficientPasswordHashCustomizations
import semmle.javascript.security.dataflow.LoopBoundInjectionCustomizations
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.PostMessageStarCustomizations
import semmle.javascript.security.dataflow.PrototypePollutionCustomizations
import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
import semmle.javascript.security.dataflow.RemotePropertyInjectionCustomizations
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import semmle.javascript.security.dataflow.StackTraceExposureCustomizations
import semmle.javascript.security.dataflow.TaintedFormatStringCustomizations
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTamperingCustomizations
import semmle.javascript.security.dataflow.UnsafeDeserializationCustomizations
import semmle.javascript.security.dataflow.UnsafeDynamicMethodAccessCustomizations
import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations
import semmle.javascript.security.dataflow.UnvalidatedDynamicMethodCallCustomizations
import semmle.javascript.security.dataflow.XmlBombCustomizations
import semmle.javascript.security.dataflow.XpathInjectionCustomizations
import semmle.javascript.security.dataflow.Xss
import semmle.javascript.security.dataflow.XxeCustomizations
import semmle.javascript.security.dataflow.ZipSlipCustomizations
import semmle.javascript.dataflow.Portals
import CoreKnowledge
import EndpointFilterUtils
import tsm_worse
import PropagationGraphs

module Metrics {  


  predicate allSinks(DataFlow::Node nd) {
    (
      nd instanceof BrokenCryptoAlgorithm::Sink or
      nd instanceof CleartextLogging::Sink or
      nd instanceof CleartextStorage::Sink or
      nd instanceof ClientSideUrlRedirect::Sink or
      nd instanceof CodeInjection::Sink or
      nd instanceof CommandInjection::Sink or
      nd instanceof ConditionalBypass::Sink or
      nd instanceof CorsMisconfigurationForCredentials::Sink or
      nd instanceof DifferentKindsComparisonBypass::Sink or
      nd instanceof FileAccessToHttp::Sink or
      nd instanceof HardcodedCredentials::Sink or
      nd instanceof HardcodedDataInterpretedAsCode::Sink or
      nd instanceof HttpToFileAccess::Sink or
      nd instanceof IndirectCommandInjection::Sink or
      nd instanceof InsecureRandomness::Sink or
      nd instanceof InsufficientPasswordHash::Sink or
      nd instanceof LoopBoundInjection::Sink or
      nd instanceof NosqlInjection::Sink or 
      nd instanceof PostMessageStar::Sink or
      nd instanceof PrototypePollution::Sink or
      nd instanceof RegExpInjection::Sink or
      nd instanceof RemotePropertyInjection::Sink or
      nd instanceof RequestForgery::Sink or
      nd instanceof ServerSideUrlRedirect::Sink or
      nd instanceof ShellCommandInjectionFromEnvironment::Sink or
      nd instanceof SqlInjection::Sink or
      nd instanceof StackTraceExposure::Sink or
      nd instanceof TaintedFormatString::Sink or
      nd instanceof TaintedPath::Sink or
      nd instanceof TypeConfusionThroughParameterTampering::Sink or
      nd instanceof UnsafeDeserialization::Sink or
      nd instanceof UnsafeDynamicMethodAccess::Sink or
      nd instanceof UnsafeJQueryPlugin::Sink or
      nd instanceof UnvalidatedDynamicMethodCall::Sink or
      nd instanceof XmlBomb::Sink or
      nd instanceof XpathInjection::Sink or
      nd instanceof DomBasedXss::Sink or
      nd instanceof ReflectedXss::Sink or
      nd instanceof StoredXss::Sink or
      nd instanceof Xxe::Sink or
      nd instanceof ZipSlip::Sink
    ) 
  }

  predicate isSinkCandidate(DataFlow::Node nd){
    exists(DataFlow::InvokeNode invk |
        nd = invk.getAnArgument()
        or
        nd = invk.(DataFlow::MethodCallNode).getReceiver()
      )
      or
      nd = any(DataFlow::PropWrite pw).getRhs()
  }

  // TODO: Think about a real source property
  // I just copies and slightly modifty the predicate IsSinkCandidate
  predicate isSourceCandidate(DataFlow::Node nd){
    exists(DataFlow::InvokeNode invk |
        nd = invk.getAnArgument()
        or
        nd = invk.(DataFlow::MethodCallNode).getReceiver()
      )
      or
      nd = any(DataFlow::PropRead pw).getALocalSource()
  }

  query predicate allSources(DataFlow::Node nd) {
    (
      nd instanceof ClientSideUrlRedirect::Source or
      nd instanceof CodeInjection::Source or
      nd instanceof CommandInjection::Source or
      nd instanceof ConditionalBypass::Source or
      nd instanceof CorsMisconfigurationForCredentials::Source or
      nd instanceof DifferentKindsComparisonBypass::Source or
      nd instanceof FileAccessToHttp::Source or
      nd instanceof HardcodedCredentials::Source or
      nd instanceof HardcodedDataInterpretedAsCode::Source or
      nd instanceof HttpToFileAccess::Source or
      nd instanceof IndirectCommandInjection::Source or
      nd instanceof InsecureRandomness::Source or
      nd instanceof InsufficientPasswordHash::Source or
      nd instanceof LoopBoundInjection::Source or
      nd instanceof NosqlInjection::Source or
      nd instanceof PostMessageStar::Source or
      nd instanceof PrototypePollution::Source or
      nd instanceof RegExpInjection::Source or
      nd instanceof RemotePropertyInjection::Source or
      nd instanceof RequestForgery::Source or
      nd instanceof ServerSideUrlRedirect::Source or
      nd instanceof ShellCommandInjectionFromEnvironment::Source or
      nd instanceof SqlInjection::Source or
      nd instanceof StackTraceExposure::Source or
      nd instanceof TaintedFormatString::Source or
      nd instanceof TaintedPath::Source or
      nd instanceof TypeConfusionThroughParameterTampering::Source or
      nd instanceof UnsafeDeserialization::Source or
      nd instanceof UnsafeDynamicMethodAccess::Source or
      nd instanceof UnsafeJQueryPlugin::Source or
      nd instanceof UnvalidatedDynamicMethodCall::Source or
      nd instanceof XmlBomb::Source or
      nd instanceof XpathInjection::Source or
      nd instanceof Shared::Source or
      nd instanceof DomBasedXss::Source or
      nd instanceof ReflectedXss::Source or
      nd instanceof StoredXss::Source or
      nd instanceof Xxe::Source or
      nd instanceof ZipSlip::Source
    ) 
  }

  query predicate allSanitizers(DataFlow::Node nd) {
    (
      nd instanceof BrokenCryptoAlgorithm::Sanitizer or
      nd instanceof CleartextStorage::Sanitizer or
      nd instanceof ClientSideUrlRedirect::Sanitizer or
      nd instanceof CodeInjection::Sanitizer or
      nd instanceof CommandInjection::Sanitizer or
      nd instanceof ConditionalBypass::Sanitizer or
      nd instanceof CorsMisconfigurationForCredentials::Sanitizer or
      nd instanceof DifferentKindsComparisonBypass::Sanitizer or
      nd instanceof FileAccessToHttp::Sanitizer or
      nd instanceof HardcodedCredentials::Sanitizer or
      nd instanceof HardcodedDataInterpretedAsCode::Sanitizer or
      nd instanceof HttpToFileAccess::Sanitizer or
      nd instanceof IndirectCommandInjection::Sanitizer or
      nd instanceof InsecureRandomness::Sanitizer or
      nd instanceof InsufficientPasswordHash::Sanitizer or
      nd instanceof NosqlInjection::Sanitizer or
      nd instanceof PostMessageStar::Sanitizer or
      nd instanceof RegExpInjection::Sanitizer or
      nd instanceof RemotePropertyInjection::Sanitizer or
      nd instanceof RequestForgery::Sanitizer or
      nd instanceof ServerSideUrlRedirect::Sanitizer or
      nd instanceof ShellCommandInjectionFromEnvironment::Sanitizer or
      nd instanceof SqlInjection::Sanitizer or
      nd instanceof TaintedFormatString::Sanitizer or
      nd instanceof TaintedPath::Sanitizer or
      nd instanceof UnsafeDeserialization::Sanitizer or
      nd instanceof UnsafeDynamicMethodAccess::Sanitizer or
      nd instanceof UnsafeJQueryPlugin::Sanitizer or
      nd instanceof UnvalidatedDynamicMethodCall::Sanitizer or
      nd instanceof XmlBomb::Sanitizer or
      nd instanceof XpathInjection::Sanitizer or
      nd instanceof DomBasedXss::Sanitizer or
      nd instanceof ReflectedXss::Sanitizer or
      nd instanceof StoredXss::Sanitizer or
      nd instanceof Xxe::Sanitizer //or
      //nd instanceof ZipSlip::S
    ) 
  }

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
predicate isKnownSink(DataFlow::Node node){    
    allSinks(node)
}

predicate isKnownSource(DataFlow::Node node){    
    allSources(node)
}

predicate isKnownSanitizer(DataFlow::Node node){    
    allSanitizers(node)
}


predicate isKnownSqlInjectionSink(DataFlow::Node node){
  node instanceof SqlInjection::Sink
}
predicate isKnownSqlInjectionSource(DataFlow::Node node){
  node instanceof SqlInjection::Source
}

predicate isKnownSqlInjectionSanitizer(DataFlow::Node node){
node instanceof SqlInjection::Sanitizer
}


predicate isKnownNoSqlInjectionSink(DataFlow::Node node){
    node instanceof NosqlInjection::Sink
}
predicate isKnownNoSqlInjectionSource(DataFlow::Node node){
    node instanceof NosqlInjection::Source
}

predicate isKnownNoSqlInjectionSanitizer(DataFlow::Node node){
  node instanceof NosqlInjection::Sanitizer
}


predicate isKnownDomBasedXssSink(DataFlow::Node node){
    node instanceof DomBasedXss::Sink
}

predicate isKnownDomBasedXssSource(DataFlow::Node node){
  node instanceof DomBasedXss::Source
}

predicate isKnownDomBasedXssSanitizer(DataFlow::Node node){
    node instanceof DomBasedXss::Sanitizer
}

predicate containsAPropertyThatIsWrittenTo(DataFlow::Node node) {
    exists(DataFlow::PropWrite pw, DataFlow::Node base |
      (
        base = pw.getBase() or
        base = pw.getBase().getImmediatePredecessor()
      ) and
      DataFlow::localFlowStep*(base, node)
    )
}
predicate isEffectiveSink(DataFlow::Node node){ 
    not    (isUnlikelySink(node) )
    and
    exists(DataFlow::CallNode call |
        call = getALikelyExternalLibraryCall() and
        node = call.getAnArgument() and
        Metrics::containsAPropertyThatIsWrittenTo(node) and
        not (
            isKnownStepSrc(node) or
            call.getReceiver().asExpr() instanceof HTTP::RequestExpr or
            call.getReceiver().asExpr() instanceof HTTP::ResponseExpr or
            call instanceof DatabaseAccess 
        ))
}

predicate predictionsSanitizer(DataFlow::Node node, PropagationGraph::Node pnode, 
  float score, boolean isKnown, boolean isCandidate, string type, string crep){
  node = pnode.asDataFlowNode() 
  and 
  exists(pnode.rep())
  and
  score = sum(TSMWorse::doGetReprScore(pnode.rep(), "san"))/count(pnode.rep())
  and 
  ((isKnown = true and isKnownSanitizer(node)) or (isKnown = false and not isKnownSanitizer(node))) 
  and
  ((pnode.isSanitizerCandidate() and isCandidate = true )
  or ((not pnode.isSanitizerCandidate()) and isCandidate = false))
  and
  type = "call"
  and
  crep = pnode.getconcatrep()   
}

predicate predictionsSource(DataFlow::Node node, PropagationGraph::Node pnode, 
  float score, boolean isKnown, boolean isCandidate, string type, string crep){
  node = pnode.asDataFlowNode() 
  and 
  exists(pnode.rep())
  and
  score = sum(TSMWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
  and 
  ((isKnown = true and isKnownSource(node)) or (isKnown = false and not isKnownSource(node))) 
  and
  ((pnode.isSourceCandidate() and getSrcType(node) = type and isCandidate = true )
  or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
  and
  crep = pnode.getconcatrep()
}

predicate predictionsSink(DataFlow::Node node, PropagationGraph::Node pnode, 
  float score, boolean isKnown, boolean isCandidate, string type, string crep){
  node = pnode.asDataFlowNode() 
  and 
  exists(pnode.rep())
  and
  score = sum(TSMWorse::doGetReprScore(pnode.rep(), "src"))/count(pnode.rep())
  and 
  ((isKnown = true and isKnownSink(node)) or (isKnown = false and not isKnownSink(node))) 
  and
  ((pnode.isSinkCandidate() and getSrcType(node) = type and isCandidate = true )
  or ((not pnode.isSourceCandidate())  and type = "unknown" and isCandidate = false))
  and
  crep = pnode.getconcatrep()
}


class RemoteCommandExecutor2 extends SystemCommandExecution, DataFlow::InvokeNode {
      int cmdArg;
    
      RemoteCommandExecutor2() {
        this = DataFlow::moduleImport("remote-exec").getACall() and
        cmdArg = 1
        or
        exists(DataFlow::SourceNode ssh2, DataFlow::SourceNode client |
          ssh2 = DataFlow::moduleImport("ssh2") and
          (client = ssh2 or client = ssh2.getAPropertyRead("Client")) and
          this = client.getAnInstantiation().getAMethodCall("exec") and
          cmdArg = 0
        )
        or
        exists(DataFlow::SourceNode ssh2stream |
          ssh2stream = DataFlow::moduleMember("ssh2-streams", "SSH2Stream") and
          this = ssh2stream.getAnInstantiation().getAMethodCall("exec") and
          cmdArg = 1
        )
      }
    
      override DataFlow::Node getACommandArgument() { result = getArgument(cmdArg) }
    
      override predicate isShellInterpreted(DataFlow::Node arg) { arg = getACommandArgument() }
    
      override predicate isSync() { none() }
    
      override DataFlow::Node getOptionsArg() { none() }
    }
}
