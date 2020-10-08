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
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations1
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations2
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations3
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations4
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations5
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations6
import semmle.javascript.security.dataflow.NosqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.PostMessageStarCustomizations
import semmle.javascript.security.dataflow.PrototypePollutionCustomizations
import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
import semmle.javascript.security.dataflow.RemotePropertyInjectionCustomizations
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentCustomizations
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import semmle.javascript.security.dataflow.SqlInjectionCustomizationsWorse
import semmle.javascript.security.dataflow.SeldonCustomizations
import semmle.javascript.security.dataflow.SeldonCustomizationsWorse
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
import semmle.javascript.security.dataflow.XssWorse
import semmle.javascript.security.dataflow.XxeCustomizations
import semmle.javascript.security.dataflow.ZipSlipCustomizations
import semmle.javascript.dataflow.Portals
import PropagationGraphs

predicate remoteSinks(DataFlow::Node nd){
  (
   // nd instanceof BrokenCryptoAlgorithm::Sink or
    //nd instanceof CleartextLogging::Sink or
    //nd instanceof CleartextStorage::Sink or
    nd instanceof ClientSideUrlRedirect::Sink or
    nd instanceof CodeInjection::Sink or
    nd instanceof CommandInjection::Sink or
    nd instanceof ConditionalBypass::Sink or
    nd instanceof CorsMisconfigurationForCredentials::Sink or
    //nd instanceof DifferentKindsComparisonBypass::Sink or
    //nd instanceof FileAccessToHttp::Sink or
    //nd instanceof HardcodedCredentials::Sink or
    //nd instanceof HardcodedDataInterpretedAsCode::Sink or
    //nd instanceof HttpToFileAccess::Sink or
    //nd instanceof IndirectCommandInjection::Sink or
    //nd instanceof InsecureRandomness::Sink or
    //nd instanceof InsufficientPasswordHash::Sink or
    //nd instanceof LoopBoundInjection::Sink or
    nd instanceof NosqlInjection::Sink or
    //nd instanceof PostMessageStar::Sink or
    //nd instanceof PrototypePollution::Sink or
    nd instanceof RegExpInjection::Sink or
    nd instanceof RemotePropertyInjection::Sink or
    nd instanceof RequestForgery::Sink or
    //nd instanceof ServerSideUrlRedirect::Sink or
    //nd instanceof ShellCommandInjectionFromEnvironment::Sink or
    nd instanceof SqlInjection::Sink or
    //nd instanceof StackTraceExposure::Sink or
    //nd instanceof TaintedFormatString::Sink or
    nd instanceof TaintedPath::Sink or
    //nd instanceof TypeConfusionThroughParameterTampering::Sink or
    nd instanceof UnsafeDeserialization::Sink or
    nd instanceof UnsafeDynamicMethodAccess::Sink or
    //nd instanceof UnsafeJQueryPlugin::Sink or
    nd instanceof UnvalidatedDynamicMethodCall::Sink or
    nd instanceof XmlBomb::Sink or
    //nd instanceof XpathInjection::Sink or
    //nd instanceof DomBasedXss::Sink or
    //nd instanceof ReflectedXss::Sink or
    //nd instanceof StoredXss::Sink or
    nd instanceof Xxe::Sink //or
    //nd instanceof ZipSlip::Sink
  ) 
}

  predicate sinkClasses(DataFlow::Node nd, string q, string repr){
    (
        nd instanceof BrokenCryptoAlgorithm::Sink and q="BrokenCryptoAlgorithm" or
        nd instanceof CleartextLogging::Sink and q="CleartextLogging" or
        nd instanceof CleartextStorage::Sink and q="CleartextStorage" or
        nd instanceof ClientSideUrlRedirect::Sink and q="ClientSideUrlRedirect" or
        nd instanceof CodeInjection::Sink and q="CodeInjection" or
        nd instanceof CommandInjection::Sink and q="CommandInjection" or
        nd instanceof ConditionalBypass::Sink and q="ConditionalBypass" or
        nd instanceof CorsMisconfigurationForCredentials::Sink and q="CorsMisconfigurationForCredentials" or
        nd instanceof DifferentKindsComparisonBypass::Sink and q="DifferentKindsComparisonBypass" or
        nd instanceof FileAccessToHttp::Sink and q="FileAccessToHttp" or
        nd instanceof HardcodedCredentials::Sink and q="HardcodedCredentials" or
        nd instanceof HardcodedDataInterpretedAsCode::Sink and q="HardcodedDataInterpretedAsCode" or
        nd instanceof HttpToFileAccess::Sink and q="HttpToFileAccess" or
        nd instanceof IndirectCommandInjection::Sink and q="IndirectCommandInjection" or
        nd instanceof InsecureRandomness::Sink and q="InsecureRandomness" or
        nd instanceof InsufficientPasswordHash::Sink and q="InsufficientPasswordHash" or
        nd instanceof LoopBoundInjection::Sink and q="LoopBoundInjection" or
        nd instanceof NosqlInjection::Sink and q="NosqlInjection" or
        nd instanceof NosqlInjection1::Sink and q="NosqlInjection1" or
        nd instanceof NosqlInjection2::Sink and q="NosqlInjection2" or
        nd instanceof PostMessageStar::Sink and q="PostMessageStar" or
        nd instanceof RegExpInjection::Sink and q="RegExpInjection" or
        nd instanceof PrototypePollution::Sink and q="PrototypePollution" or
        nd instanceof RemotePropertyInjection::Sink and q="RemotePropertyInjection" or
        nd instanceof RequestForgery::Sink and q="RequestForgery" or
        nd instanceof ServerSideUrlRedirect::Sink and q="ServerSideUrlRedirect" or
        nd instanceof ShellCommandInjectionFromEnvironment::Sink and q="ShellCommandInjectionFromEnvironment" or
        nd instanceof SqlInjection::Sink and q="SqlInjection" or
        nd instanceof StackTraceExposure::Sink and q="StackTraceExposure" or
        nd instanceof TaintedFormatString::Sink and q="TaintedFormatString" or
        nd instanceof TaintedPath::Sink and q="TaintedPath" or
        nd instanceof TypeConfusionThroughParameterTampering::Sink and q="TypeConfusionThroughParameterTampering" or
        nd instanceof UnsafeDeserialization::Sink and q="UnsafeDeserialization" or
        nd instanceof UnsafeDynamicMethodAccess::Sink and q="UnsafeDynamicMethodAccess" or
        nd instanceof UnsafeJQueryPlugin::Sink and q="UnsafeJQueryPlugin" or
        nd instanceof UnvalidatedDynamicMethodCall::Sink and q="UnvalidatedDynamicMethodCall" or
        nd instanceof XmlBomb::Sink and q="XmlBomb" or
        nd instanceof XpathInjection::Sink and q="XpathInjection" or
        nd instanceof DomBasedXss::Sink and q="DomBasedXss" or
        nd instanceof StoredXss::Sink and q="StoredXss" or
        nd instanceof ReflectedXss::Sink and q="ReflectedXss" or
        nd instanceof Xxe::Sink and q="Xxe" or
        nd instanceof ZipSlip::Sink and q="ZipSlip" 
    ) and 
    repr = PropagationGraph::getconcatrep(nd)
    }

  predicate allSinks(DataFlow::Node nd){
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