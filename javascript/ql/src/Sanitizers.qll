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
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.TaintedFormatStringCustomizations
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import semmle.javascript.security.dataflow.UnsafeDeserializationCustomizations
import semmle.javascript.security.dataflow.UnsafeDynamicMethodAccessCustomizations
import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations
import semmle.javascript.security.dataflow.UnvalidatedDynamicMethodCallCustomizations
import semmle.javascript.security.dataflow.XmlBombCustomizations
import semmle.javascript.security.dataflow.XpathInjectionCustomizations
import semmle.javascript.security.dataflow.Xss
import semmle.javascript.security.dataflow.XssWorse
import semmle.javascript.security.dataflow.XxeCustomizations
import semmle.javascript.security.dataflow.ZipSlipCustomizations
import semmle.javascript.dataflow.Portals
import PropagationGraphs



predicate remoteSanitizers(DataFlow::Node nd){
  (
    //nd instanceof BrokenCryptoAlgorithm::Sanitizer or
    //nd instanceof CleartextStorage::Sanitizer or
    nd instanceof ClientSideUrlRedirect::Sanitizer or
    nd instanceof CodeInjection::Sanitizer or
    nd instanceof CommandInjection::Sanitizer or
    nd instanceof ConditionalBypass::Sanitizer or
    nd instanceof CorsMisconfigurationForCredentials::Sanitizer or
    //nd instanceof DifferentKindsComparisonBypass::Sanitizer or
    //nd instanceof FileAccessToHttp::Sanitizer or
    //nd instanceof HardcodedCredentials::Sanitizer or
    //nd instanceof HardcodedDataInterpretedAsCode::Sanitizer or
    //nd instanceof HttpToFileAccess::Sanitizer or
    //nd instanceof IndirectCommandInjection::Sanitizer or
    //nd instanceof InsecureRandomness::Sanitizer or
    //nd instanceof InsufficientPasswordHash::Sanitizer or
    nd instanceof NosqlInjection::Sanitizer or
    //nd instanceof PostMessageStar::Sanitizer or
    nd instanceof RegExpInjection::Sanitizer or
    nd instanceof RemotePropertyInjection::Sanitizer or
    nd instanceof RequestForgery::Sanitizer or
    //nd instanceof ServerSideUrlRedirect::Sanitizer or
    //nd instanceof ShellCommandInjectionFromEnvironment::Sanitizer or
    nd instanceof SqlInjection::Sanitizer or
    //nd instanceof TaintedFormatString::Sanitizer or
    nd instanceof TaintedPath::Sanitizer or
    nd instanceof UnsafeDeserialization::Sanitizer or
    nd instanceof UnsafeDynamicMethodAccess::Sanitizer or
    //nd instanceof UnsafeJQueryPlugin::Sanitizer or
    nd instanceof UnvalidatedDynamicMethodCall::Sanitizer or
    nd instanceof XmlBomb::Sanitizer or
    //nd instanceof XpathInjection::Sanitizer or
    nd instanceof DomBasedXss::Sanitizer or
    //nd instanceof ReflectedXss::Sanitizer or
    //nd instanceof StoredXss::Sanitizer or
    nd instanceof Xxe::Sanitizer //or
    //nd instanceof ZipSlip::San
  ) 
}

predicate sanitizerClasses(DataFlow::Node nd, string q, string repr){
    (
        nd instanceof BrokenCryptoAlgorithm::Sanitizer and q="BrokenCryptoAlgorithm" or
        nd instanceof CleartextStorage::Sanitizer and q="CleartextStorage" or
        nd instanceof ClientSideUrlRedirect::Sanitizer and q="ClientSideUrlRedirect" or
        nd instanceof CodeInjection::Sanitizer and q="CodeInjection" or
        nd instanceof CommandInjection::Sanitizer and q="CommandInjection" or
        nd instanceof ConditionalBypass::Sanitizer and q="ConditionalBypass" or
        nd instanceof CorsMisconfigurationForCredentials::Sanitizer and q="CorsMisconfigurationForCredentials" or
        nd instanceof DifferentKindsComparisonBypass::Sanitizer and q="DifferentKindsComparisonBypass" or
        nd instanceof FileAccessToHttp::Sanitizer and q="FileAccessToHttp" or
        nd instanceof HardcodedCredentials::Sanitizer and q="HardcodedCredentials" or
        nd instanceof HardcodedDataInterpretedAsCode::Sanitizer and q="HardcodedDataInterpretedAsCode" or
        nd instanceof HttpToFileAccess::Sanitizer and q="HttpToFileAccess" or
        nd instanceof IndirectCommandInjection::Sanitizer and q="IndirectCommandInjection" or
        nd instanceof InsecureRandomness::Sanitizer and q="InsecureRandomness" or
        nd instanceof InsufficientPasswordHash::Sanitizer and q="InsufficientPasswordHash" or
        nd instanceof NosqlInjection::Sanitizer and q="NosqlInjection" or
        nd instanceof PostMessageStar::Sanitizer and q="PostMessageStar" or
        nd instanceof RegExpInjection::Sanitizer and q="RegExpInjection" or
        nd instanceof RemotePropertyInjection::Sanitizer and q="RemotePropertyInjection" or
        nd instanceof RequestForgery::Sanitizer and q="RequestForgery" or
        nd instanceof ServerSideUrlRedirect::Sanitizer and q="ServerSideUrlRedirect" or
        nd instanceof ShellCommandInjectionFromEnvironment::Sanitizer and q="ShellCommandInjectionFromEnvironment" or
        nd instanceof SqlInjection::Sanitizer and q="SqlInjection" or
        nd instanceof TaintedFormatString::Sanitizer and q="TaintedFormatString" or
        nd instanceof TaintedPath::Sanitizer and q="TaintedPath" or
        nd instanceof UnsafeDeserialization::Sanitizer and q="UnsafeDeserialization" or
        nd instanceof UnsafeDynamicMethodAccess::Sanitizer and q="UnsafeDynamicMethodAccess" or
        nd instanceof UnsafeJQueryPlugin::Sanitizer and q="UnsafeJQueryPlugin" or
        nd instanceof UnvalidatedDynamicMethodCall::Sanitizer and q="UnvalidatedDynamicMethodCall" or
        nd instanceof XmlBomb::Sanitizer and q="XmlBomb" or
        nd instanceof XpathInjection::Sanitizer and q="XpathInjection" or
        nd instanceof DomBasedXss::Sanitizer and q="DomBasedXss" or
        nd instanceof ReflectedXss::Sanitizer and q="ReflectedXss" or
        nd instanceof StoredXss::Sanitizer and q="StoredXss" or
        nd instanceof Xxe::Sanitizer and q="Xxe"
      //nd instanceof ZipSlip::S
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}

predicate sanitizerSqlClasses(DataFlow::Node nd, string q, string repr){
    (           
        nd instanceof SqlInjection::Sanitizer and q="SqlInjection" or
        nd instanceof SqlInjectionWorse::Sanitizer and q="SqlInjectionWorse"       
    ) and
    repr = PropagationGraph::getconcatrep(nd)
}

  predicate allSanitizers(DataFlow::Node nd){
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
  