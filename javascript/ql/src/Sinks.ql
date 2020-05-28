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
import PropagationGraphs

from PropagationGraph::Node pnd, DataFlow::Node nd
where
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
  ) and
  nd = pnd.asDataFlowNode()
select pnd
