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

from Portal p, DataFlow::Node nd
where
  (
    nd instanceof BrokenCryptoAlgorithm::Source or
    nd instanceof CleartextLogging::Source or
    nd instanceof CleartextStorage::Source or
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
  ) and
  nd = p.getAnExitNode(_)
select p.toString()
