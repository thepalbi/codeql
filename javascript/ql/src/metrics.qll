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
module ReprScores{
    float getReprScore(string repr, string t){
        repr = "(parameter 0 (member createElement *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (parameter 1 (root https://www.npmjs.com/package/request)))" and t = "src" and result = 1.0 or 
repr = "(return (member encode (return (member TextEncoder (global)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member progress (return (member getService (parameter 0 (member createFileCommands (return (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member setTimeout (member window *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member parent (member window *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member parent *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return (member Section (parameter 5 (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 (member mixin *))))))" and t = "snk" and result = 1.0 or 
repr = "(member Name *)" and t = "src" and result = 1.0 or 
repr = "(return (member replace (parameter 0 *)))" and t = "san" and result = 1.0 or 
repr = "(member project *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member error (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member opener *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member eval (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange (member document *)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace *))" and t = "san" and result = 1.0 or 
repr = "(return (member createTextNode (member document (global))))" and t = "san" and result = 0.5 or 
repr = "(parameter 0 (member error (return (member getLogger (root https://www.npmjs.com/package/log4js)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member createElement (member document *)))" and t = "src" and result = 0.5 or 
repr = "(return (member createElement (member document *)))" and t = "san" and result = 0.5 or 
repr = "(parameter 0 (parameter 1 (member addEventListener *)))" and t = "src" and result = 1.0 or 
repr = "(return (member createContextualFragment (return (member createRange (member document *)))))" and t = "san" and result = 1.0 or 
repr = "(return (member parse (member JSON *)))" and t = "san" and result = 0.125 or 
repr = "(parameter 1 (member open (instance (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (parameter 0 *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member opener (global))))" and t = "snk" and result = 1.0 or 
repr = "(member response *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member setTimeout (member window (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member error (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member self (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member require *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createTextNode (member document *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (parameter 6 (parameter 2 (member define *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 (member mixin (parameter 2 (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member log (member console (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member log (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 2 (parameter 1 (member define *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (parameter 5 (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member open (instance (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member createContextualFragment *))" and t = "san" and result = 0.25 or 
repr = "(parameter 2 (member log *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member require *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member RegExp (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createElement (member document (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member error (return (member getLogger *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member startNode (instance (member Parser (parameter 0 (member defineProperty (member Object *)))))))" and t = "san" and result = 0.278269 or 
repr = "(parameter 1 (member error (return (member getLogger (root https://www.npmjs.com/package/log4js)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange (member document (global))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member require *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (member head *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getElementById (member document (global))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 2 (parameter 1 *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (member body (member document (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member then *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member window *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 3 (parameter 1 (member define (global))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (parameter 5 (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance *)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member _createDebugCommandButton (instance (member DebugPane (return (parameter 1 *))))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return (member Section (parameter 5 (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (member window (global)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return (member Section (parameter 5 *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member addEventListener (global))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return (member node (parameter 1 *)))))" and t = "snk" and result = 1.0 or 
repr = "(member body (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(return (member toUrl (parameter 1 *)))" and t = "src" and result = 0.25 or 
repr = "(parameter 0 (member createContextualFragment *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member require (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (member body *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance (member DebugPane (return (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance (member Tooltip (return (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return (member node (parameter 1 (parameter 1 *))))))" and t = "snk" and result = 1.0 or 
repr = "(member textContent *)" and t = "src" and result = 1.0 or 
repr = "(member name (parameter 1 *))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member open (instance *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getElementById (member document *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member error (member console (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (parameter 5 (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member encode *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member log (member console (member window *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member self *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 1 *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member progress (return (member getService (parameter 0 (member createFileCommands *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member Function *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return (member node *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member RegExp *))" and t = "src" and result = 0.25 or 
repr = "(parameter 0 (member appendChild (return (member createElement (parameter 6 (parameter 2 *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return (member Section (parameter 5 (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance (member Tooltip (return (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member get *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member opener (member window *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 6 (parameter 1 (member define *)))" and t = "src" and result = 0.5 or 
repr = "(parameter 0 (member require (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member open *))" and t = "snk" and result = 1.0 or 
repr = "(return (member encode (instance *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member createElement (member document *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance (member Tooltip (return *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member error (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(return (member valueFor *))" and t = "src" and result = 1.0 or 
repr = "(return (member createLink *))" and t = "src" and result = 0.25 or 
repr = "(return (member createLink *))" and t = "san" and result = 0.25 or 
repr = "(parameter 0 (member error (member console (global))))" and t = "snk" and result = 1.0 or 
repr = "(return (member RegExp (global)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member log (member console (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createTextNode (member document (global))))" and t = "snk" and result = 0.125 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 (member mixin (parameter 2 (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member setTimeout *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (return (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (member body (member document *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member setTimeout (global)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member error (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(return (member createTextNode *))" and t = "san" and result = 1.0 or 
repr = "(member key *)" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member defineProperty (member Object *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance (member Tooltip (return (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (instance (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member formatMessage (parameter 1 (parameter 1 (member define *)))))" and t = "src" and result = 0.25 or 
repr = "(parameter 1 (member error *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member error (return (member getLogger *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (parameter 5 *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 3 *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (instance (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member opener (member window (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (return (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (return (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (member document (member window *))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member formatMessage (parameter 1 (parameter 1 (member define (global))))))" and t = "san" and result = 1.0 or 
repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 1.0 or 
repr = "(return (member enforceTextDirWithUcc *))" and t = "san" and result = 0.55 or 
repr = "(parameter 0 (member log (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 2 (member require (global)))" and t = "snk" and result = 1.0 or 
repr = "(member responseText *)" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member open (return *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member error *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member log (member console *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 (member mixin (parameter 2 *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member defineProperty (member Object (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (root https://www.npmjs.com/package/request))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member setItem *))" and t = "snk" and result = 1.0 or 
repr = "(return (member createElement (parameter 4 *)))" and t = "src" and result = 0.375 or 
repr = "(return (member createElement (parameter 4 *)))" and t = "san" and result = 0.375 or 
repr = "(member ANull (parameter 1 (member init (parameter 0 (member define (global))))))" and t = "src" and result = 0.194444 or 
repr = "(parameter 0 (member postMessage (member parent (global))))" and t = "snk" and result = 1.0 or 
repr = "(return (member createElement (parameter 6 (parameter 2 *))))" and t = "src" and result = 0.0625 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (return *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member log *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member createContextualFragment (return (member createRange *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 2 (parameter 1 (member define (global))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance (member DebugPane *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 3 (parameter 1 (member define *)))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return (member replace *))))))" and t = "san" and result = 1.0 or 
repr = "(return (member _createDebugCommandButton (instance (member _createDomNode (instance (member DebugPane (return (parameter 1 (member define *)))))))))" and t = "src" and result = 1.0 or 
repr = "(return (member encodeURIComponent *))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node *))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace (return *)))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member log (member console (global))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member replace *))" and t = "snk" and result = 1.0 or 
repr = "(return (member encode (instance (member TextEncoder (global)))))" and t = "san" and result = 1.0 or 
repr = "(return (member createElement (parameter 6 (parameter 2 (member define *)))))" and t = "san" and result = 0.0625 or 
repr = "(return (member formatMessage *))" and t = "src" and result = 1.0 or 
repr = "(member textContent (parameter 0 (member appendChild (return *))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (parameter 6 *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance (member DebugPane (return (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (return (parameter 1 (member define *)))))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member parse *))" and t = "src" and result = 0.375 or 
repr = "(return (member parseType (instance (member TypeParser (return (member init (parameter 0 (member define *))))))))" and t = "san" and result = 0.333333 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 1 (member apply *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member RegExp *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 5 (parameter 1 (member define *)))" and t = "src" and result = 0.5 or 
repr = "(parameter 0 (member appendChild (parameter 1 (member _createContents (parameter 1 (member mixin (parameter 2 (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(member startLoc (instance (member Parser (parameter 0 (member defineProperty (member Object *))))))" and t = "src" and result = 0.125 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (instance (member Section (return (parameter 1 *))))))))" and t = "snk" and result = 1.0 or 
repr = "(member textContent (parameter 0 (member appendChild *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 4 (parameter 1 (member define (global))))))" and t = "snk" and result = 0.375 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance (member DebugPane (return *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return (member node (parameter 1 (parameter 1 (member define *)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member open (return (member XMLHttpRequest (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member defineProperty *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage (parameter 1 (parameter 1 (member define *)))))" and t = "snk" and result = 0.125 or 
repr = "(parameter 0 (member appendChild (parameter 0 *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member send (instance *)))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (member document (global))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member log *))" and t = "snk" and result = 1.0 or 
repr = "(return (member apply *))" and t = "src" and result = 0.25 or 
repr = "(return (member apply *))" and t = "san" and result = 0.25 or 
repr = "(member body *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member get (return *))))" and t = "snk" and result = 0.75 or 
repr = "(parameter 1 (member info *))" and t = "snk" and result = 1.0 or 
repr = "(member textContent (parameter 0 *))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (member document *)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getActionElement (return (member Section *))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member postMessage (member parent (member window (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member log (member console (member window (global)))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (root https://www.npmjs.com/package/request)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member removeEventListener (global))))" and t = "src" and result = 1.0 or 
repr = "(return (member encode (return *)))" and t = "san" and result = 1.0 or 
repr = "(return (member createElement *))" and t = "src" and result = 0.25 or 
repr = "(return (member createElement *))" and t = "san" and result = 0.25 or 
repr = "(parameter 1 (member call *))" and t = "snk" and result = 1.0 or 
repr = "(return (member encodeURIComponent (global)))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 3 (parameter 1 *))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member replace (return (member replace (return *)))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member node (parameter 2 *)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member encode (instance (member TextEncoder *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member insertBefore (return (member node (parameter 1 (parameter 1 (member define (global))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 1 (member open (return (member XMLHttpRequest *))))" and t = "snk" and result = 1.0 or 
repr = "(member id *)" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (member document (member window (global)))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on *)))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (parameter 1 (member on (parameter 0 (parameter 1 *)))))" and t = "src" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (parameter 0 (member _renderVariable (instance (member DebugPane (return (parameter 1 (member define (global))))))))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance *)))))" and t = "snk" and result = 1.0 or 
repr = "(return (member parse (member JSON (global))))" and t = "san" and result = 1.0 or 
repr = "(parameter 1 (member formatMessage *))" and t = "snk" and result = 1.0 or 
repr = "(return (member formatMessage (parameter 1 *)))" and t = "san" and result = 0.25 or 
repr = "(parameter 1 (member progress (return (member getService (parameter 0 (member createFileCommands (return (parameter 1 (member define (global))))))))))" and t = "snk" and result = 0.25 or 
repr = "(return (member encode (return (member TextEncoder *))))" and t = "san" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member getElementById *))))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member get (return (parameter 1 (member define (global))))))" and t = "src" and result = 0.625 or 
repr = "(parameter 0 (member eval *))" and t = "snk" and result = 1.0 or 
repr = "(parameter 0 (member appendChild (return (member createElement (parameter 6 (parameter 2 (member define (global))))))))" and t = "snk" and result = 1.0 or 
repr = "(return (member node *))" and t = "src" and result = 0.125 or 
repr = "(return (member node *))" and t = "san" and result = 0.125 or 
repr = "(parameter 0 (parameter 1 (member then (return *))))" and t = "src" and result = 0.5 or 
repr = "(parameter 0 (member appendChild (return (member contentContainer (instance (member Tooltip *))))))" and t = "snk" and result = 1.0 

    }    

    predicate allSinks(PropagationGraph::Node pnd, DataFlow::Node nd){
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
        }
    
        query predicate allSources(PropagationGraph::Node pnd, DataFlow::Node nd){
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
          ) and
          nd = pnd.asDataFlowNode()
          }
          query predicate allSanitizers(PropagationGraph::Node pnd, DataFlow::Node nd){
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
            ) and
            // nd = p.getAnExitNode(_)
            nd = pnd.asDataFlowNode()
            }
    
    }