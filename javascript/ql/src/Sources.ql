/**
 * @kind graph
 */
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


predicate remoteSources(DataFlow::Node nd){
    (
    nd instanceof ClientSideUrlRedirect::Source or
    nd instanceof CodeInjection::Source or
    nd instanceof CommandInjection::Source or
    nd instanceof ConditionalBypass::Source or
    nd instanceof CorsMisconfigurationForCredentials::Source or
    //nd instanceof DifferentKindsComparisonBypass::Source or
    //nd instanceof FileAccessToHttp::Source or
   // nd instanceof HardcodedCredentials::Source or
   // nd instanceof HardcodedDataInterpretedAsCode::Source or
    //nd instanceof HttpToFileAccess::Source or
   // nd instanceof IndirectCommandInjection::Source or
   // nd instanceof InsecureRandomness::Source or
    //nd instanceof InsufficientPasswordHash::Source or
    //nd instanceof LoopBoundInjection::Source or
    nd instanceof NosqlInjection::Source or
    //nd instanceof PostMessageStar::Source or
    //nd instanceof PrototypePollution::Source or
    nd instanceof RegExpInjection::Source or
    nd instanceof RemotePropertyInjection::Source or
    nd instanceof RequestForgery::Source or
   // nd instanceof ServerSideUrlRedirect::Source or
   // nd instanceof ShellCommandInjectionFromEnvironment::Source or
    nd instanceof SqlInjection::Source or
   // nd instanceof StackTraceExposure::Source or
   // nd instanceof TaintedFormatString::Source or
    nd instanceof TaintedPath::Source or
    //nd instanceof TypeConfusionThroughParameterTampering::Source or
    nd instanceof UnsafeDeserialization::Source or
    nd instanceof UnsafeDynamicMethodAccess::Source or
   // nd instanceof UnsafeJQueryPlugin::Source or
    nd instanceof UnvalidatedDynamicMethodCall::Source or
    nd instanceof XmlBomb::Source or
   // nd instanceof XpathInjection::Source or
   // nd instanceof Shared::Source or
    nd instanceof DomBasedXss::Source or
   // nd instanceof ReflectedXss::Source or
  //  nd instanceof StoredXss::Source or
    nd instanceof Xxe::Source //or
  //  nd instanceof ZipSlip::Source
  ) 
}

predicate sourceNoSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof NosqlInjection::Source and q="NosqlInjection" or
    nd instanceof NosqlInjection1::Source and q="NosqlInjection1" or
    nd instanceof NosqlInjection2::Source and q="NosqlInjection2" or
    nd instanceof NosqlInjection3::Source and q="NosqlInjection3" or
    nd instanceof NosqlInjection4::Source and q="NosqlInjection4" or
    nd instanceof NosqlInjection5::Source and q="NosqlInjection5" or 
    nd instanceof NosqlInjection6::Source and q="NosqlInjection6" or
    nd instanceof NosqlInjectionWorse::Source and q="NosqlInjectionWorse" 
    ) and   
    repr = PropagationGraph::getconcatrep(nd)
}

predicate sourceSqlClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof SqlInjection::Source and q="SqlInjection" or  
    nd instanceof  SqlInjectionWorse::Source and q="SqlInjectionWorse" 
    ) and  
    repr = PropagationGraph::getconcatrep(nd)
}

query predicate sourceXssClasses(DataFlow::Node nd, string q, string repr){
    (nd instanceof DomBasedXss::Source and q="DomBasedXss" or
    nd instanceof DomBasedXssWorse::Source and q="DomBasedXssWorse"
    ) and    
    repr = PropagationGraph::getconcatrep(nd)
}
predicate sourceClasses(DataFlow::Node nd, string q, string repr){
    (
        nd instanceof ClientSideUrlRedirect::Source and q="ClientSideUrlRedirect" or
        nd instanceof CodeInjection::Source and q="CodeInjection" or
        nd instanceof CommandInjection::Source and q="CommandInjection" or
        nd instanceof ConditionalBypass::Source and q="ConditionalBypass" or
        nd instanceof CorsMisconfigurationForCredentials::Source and q="CorsMisconfigurationForCredentials" or
        nd instanceof DifferentKindsComparisonBypass::Source and q="DifferentKindsComparisonBypass" or
        nd instanceof FileAccessToHttp::Source and q="FileAccessToHttp" or
        nd instanceof HardcodedCredentials::Source and q="HardcodedCredentials" or
        nd instanceof HardcodedDataInterpretedAsCode::Source and q="HardcodedDataInterpretedAsCode" or
        nd instanceof HttpToFileAccess::Source and q="HttpToFileAccess" or
        nd instanceof IndirectCommandInjection::Source and q="IndirectCommandInjection" or
        nd instanceof InsecureRandomness::Source and q="InsecureRandomness" or
        nd instanceof InsufficientPasswordHash::Source and q="InsufficientPasswordHash" or
        nd instanceof LoopBoundInjection::Source and q="LoopBoundInjection" or
        nd instanceof NosqlInjection::Source and q="NosqlInjection" or
        nd instanceof PrototypePollution::Source and q="PrototypePollution" or
        nd instanceof PostMessageStar::Source and q="PostMessageStar" or
        nd instanceof RegExpInjection::Source and q="RegExpInjection" or
        nd instanceof RemotePropertyInjection::Source and q="RemotePropertyInjection" or
        nd instanceof RequestForgery::Source and q="RequestForgery" or
        nd instanceof ServerSideUrlRedirect::Source and q="ServerSideUrlRedirect" or
        nd instanceof ShellCommandInjectionFromEnvironment::Source and q="ShellCommandInjectionFromEnvironment" or
        nd instanceof SqlInjection::Source and q="SqlInjection" or
        nd instanceof StackTraceExposure::Source and q="StackTraceExposure" or
        nd instanceof TaintedFormatString::Source and q="TaintedFormatString" or
        nd instanceof TaintedPath::Source and q="TaintedPath" or
        nd instanceof TypeConfusionThroughParameterTampering::Source and q="TypeConfusionThroughParameterTampering" or
        nd instanceof UnsafeDeserialization::Source and q="UnsafeDeserialization" or
        nd instanceof UnsafeDynamicMethodAccess::Source and q="UnsafeDynamicMethodAccess" or
        nd instanceof UnsafeJQueryPlugin::Source and q="UnsafeJQueryPlugin" or
        nd instanceof UnvalidatedDynamicMethodCall::Source and q="UnvalidatedDynamicMethodCall" or
        nd instanceof XmlBomb::Source and q="XmlBomb" or
        nd instanceof XpathInjection::Source and q="XpathInjection" or
        nd instanceof Shared::Source and q="Shared" or
        nd instanceof DomBasedXss::Source and q="DomBasedXss" or
        nd instanceof ReflectedXss::Source and q="ReflectedXss" or
        nd instanceof StoredXss::Source and q="StoredXss" or
        nd instanceof Xxe::Source and q="Xxe" or
        nd instanceof ZipSlip::Source and q="ZipSlip"     
  ) and 
  repr = PropagationGraph::getconcatrep(nd)
  }

predicate allSources(DataFlow::Node nd){
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