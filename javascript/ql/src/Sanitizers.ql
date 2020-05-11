import javascript
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithmCustomizations
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
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import semmle.javascript.security.dataflow.PostMessageStarCustomizations
import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
import semmle.javascript.security.dataflow.RemotePropertyInjectionCustomizations
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import semmle.javascript.security.dataflow.TaintedFormatStringCustomizations
import semmle.javascript.security.dataflow.TaintedPathCustomizations
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
    nd instanceof Xxe::Sanitizer or
    nd instanceof ZipSlip::Sanitizer
  ) and
  nd = p.getAnExitNode(_)
select p.toString()
