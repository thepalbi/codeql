import javascript
import semmle.javascript.ApiGraphs


private predicate callFromImport(string library, DataFlow::InvokeNode invk) {
  invk = API::moduleImport(library).getASuccessor*().getAnInvocation()
}

private predicate isCallBackArgument(DataFlow::Node callBack, DataFlow::InvokeNode invk) {
callBack = invk.getABoundCallbackParameter(_,_)
}

private predicate isCallBack(DataFlow::Node node) {
  exists(int boundArgs, DataFlow::FunctionNode fn |
    fn = node.getABoundFunctionValue(boundArgs)
    )
}

predicate isCandidateSource(DataFlow::Node source, string library) {
  exists (DataFlow::InvokeNode call, DataFlow::Node callback  |
    isRelevant(call) and callFromImport(library, call) and
    isCallBackArgument(callback, call) and source = callback
  )
}

predicate isCandidateSink(DataFlow::Node sink, string library) {
  //library =  targetLibrary() and
  exists (DataFlow::InvokeNode call, DataFlow::Node arg  |
  isRelevant(call) and callFromImport(library, call) and
  (arg = call.getAnArgument() or arg = call.(DataFlow::MethodCallNode).getReceiver())
  and not isCallBackArgument(arg, call) 
  and not isCallBack(arg) 
  and sink = arg  
  )
}

predicate testSink(DataFlow::Node sink, string library, string rep) {
  isCandidateSink(sink, library) and 
  rep = chooseBestRep(sink,_) and 
  rep in ["(parameter 1 (return (member query *)))",
      "(parameter 0 (return (member query *)))",
      "(parameter 2 (return (member query *)))"]
}

/**
 * Holds if `nd` is relevant to program semantics.
 */
predicate isRelevant(DataFlow::Node nd) {
  // exclude externs files (i.e., our manually-written API models) and ambient files (such as
  // TypeScript `.d.ts` files); there is no real data flow going on in those
  not nd.getTopLevel().isExterns() and
  not nd.getTopLevel().isAmbient() and
  nd.getBasicBlock() instanceof ReachableBasicBlock
}

/**
 * Gets the maximum depth of a candidate representation.
 *
 * Increasing this bound will generate more candidate representations, but
 * will generally negatively affect performance. Note that rare candidates are
 * are filtered out above, so increasing the bound beyond a certain threshold may
 * not actually yield new candidates.
 */
private int maxdepth() { result = 5 }

/** Gets a node that the main module of package `pkgName` exports. */
private DataFlow::Node getAnExport(string pkgName) {
  exists(NPMPackage pkg, Module m | pkg.getPackageName() = pkgName and m = pkg.getMainModule() |
    exists(AnalyzedPropertyWrite apw |
      apw.writes(m.(AnalyzedModule).getModuleObject(), "exports", result)
    )
    or
    m.(ES2015Module).getAnExportedValue("default") = result 
    // m.(ES2015Module).exports("default", result.(DataFlow::ValueNode).getAstNode())
  )
}

/** Gets a node that the main module of `pkgName` exports under the name `prop`. */
private DataFlow::Node getAnExport(string pkgName, string prop) {
  exists(NPMPackage pkg, AnalyzedModule m, AnalyzedPropertyWrite apw |
    pkg.getPackageName() = pkgName and
    m = pkg.getMainModule() and
    apw.writes(m.getAnExportsValue(), prop, result)
  )
}

/**
 * Gets a candidate representation of `nd` as a (suffix of an) access path.
 */
string candidateRep(DataFlow::Node nd, int depth) {
  result = candidateRep(nd, depth, _)
}
string candidateRep(DataFlow::Node nd, int depth, boolean asRhs) {
  // static invoke in the same file
  (
    isRelevant(nd) and 
    nd instanceof DataFlow::CallNode and
    nd.(DataFlow::CallNode).getACallee().getFile()=nd.getFile()
    and depth=1 
    and result = "(return " + nd.(DataFlow::CallNode).getACallee().getName() + ")"
    and asRhs = false
  ) or
  // the global object
  isRelevant(nd) and
  nd = DataFlow::globalObjectRef() and
  result = "(global)" and
  depth = 1 and
  asRhs = false
  or
  // package imports/exports
  isRelevant(nd) and
  exists(string pkg |
    nd = DataFlow::moduleImport(pkg) and
    // avoid picking up local imports
    pkg.regexpMatch("[^./].*") and
    asRhs = false
    or
    nd = getAnExport(pkg).getALocalSource() and
    asRhs = true
  |
    result = "(root https://www.npmjs.com/package/" + pkg + ")" and
    depth = 1
  )
  or
  // compound representations
  exists(DataFlow::SourceNode base, string step, string baserep |
    (
      baserep = candidateRep(base, depth - 1, _) and
      // bound maximum depth of candidate representation
      depth <= maxdepth()
      or
      baserep = "*" and
      depth = 1 and
      // avoid creating trivial representations like `(return *)`
      step.regexpMatch("(member|parameter) [^\\d].*") and
      isRelevant(nd)
    ) and
    result = "(" + step + " " + baserep + ")"
  |
    // members
    exists(string prop |
      nd = base.getAPropertyRead(prop) and
      asRhs = false
      or
      nd = base.getAPropertyWrite(prop).getRhs().getALocalSource() and
      asRhs = true
    |
      step = "member " + prop
    )
    or
    // instances
    (
      nd = base.getAnInstantiation() and
      asRhs = false
      or
      nd = base.(DataFlow::ClassNode).getAnInstanceReference() and
      asRhs = false
    ) and
    step = "instance"
    or
    // parameters
    exists(string p |
      exists(int i |
        nd = base.(DataFlow::FunctionNode).getParameter(i) and
        asRhs = false
        or
        nd = base.(DataFlow::InvokeNode).getArgument(i) and
        asRhs = true
        or 
        i = -1 and nd = base.(DataFlow::CallNode).getReceiver() and
        asRhs = true
      |
        p = i.toString()
      )
      or
      nd = base.(DataFlow::FunctionNode).getAParameter() and
      p = nd.(DataFlow::ParameterNode).getName() and
      asRhs = false
    |
      step = "parameter " + p
    )
    or
    // return values
    (
      nd = base.(DataFlow::FunctionNode).getAReturn().getALocalSource() and
      asRhs = true
      or
      nd = base.getAnInvocation() and
      asRhs = false
    ) and
    step = "return"
  )
  or
  // named exports, which are treated as members of packages
  isRelevant(nd) and
  exists(string pkg, string m, string baserep |
    nd = getAnExport(pkg, m).getALocalSource() and
    baserep = "(root https://www.npmjs.com/package/" + pkg + ")" and
    result = "(member " + m + " " + [baserep, "*"] + ")" and
    depth = 2 and
    asRhs = true
  )
  or
  // global variables, which are treated as members of the global object
  isRelevant(nd) and
  exists(string g |
    nd = DataFlow::globalVarRef(g) and
    asRhs = false
    or
    exists(AssignExpr assgn |
      assgn.getLhs() = DataFlow::globalVarRef(g).asExpr() and
      nd = assgn.getRhs().flow().getALocalSource()
    ) and
    asRhs = true
  |
    result = "(member " + g + " (global))" and
    depth = 2
  )
  or
  // we ignore `await`
  exists(DataFlow::SourceNode base |
    base.flowsToExpr(nd.asExpr().(AwaitExpr).getOperand()) and
    result = candidateRep(base, depth, asRhs)
  )
}

string preciseRep(DataFlow::Node nd, int depth, boolean asRhs) {
  result = candidateRep(nd, depth, asRhs) and
  not result.matches(genericMemberPattern())
}

string genericMemberPattern() {
  exists(ExternalType tp |
    tp.getName() in ["Array", "Function", "Object", "Promise", "String"] and
    result = "%(member " + tp.getAMember().getName() + " *)%"
  )
}

/**
  * Choose one repr for a sink
  * Prioritizes the use of member instead of receivers
  */
 string chooseBestRep2(DataFlow::Node sink, boolean asRhs) {
  result = max(string rep, int depth, int score | 
    rep = candidateRep(sink, depth, asRhs) 
    and score = count (  rep.indexOf("member"))*4
    +  count (  rep.indexOf("return"))*3
    +  count (  rep.indexOf("parameter"))*5
    // Penalizes the receivers againts members
    -  count (  rep.indexOf("parameter -1"))*8
    | rep order by score, depth, rep) 
}

/**
 * Returns one `canonical` representation for a node
 * For sinks it prioritizes paterns like `parameter x (return member fun )
 * and the use of external functions, penalizes the receiver as parameter
 */
string chooseBestRep(DataFlow::Node sink, boolean asRhs) {
  result =
    max(string rep, int depth, int score |
      rep = candidateRep(sink, depth, asRhs) and
      exists(int cm, int cr, int cp, int cpr, int croot, int plus |
        cm = count(rep.indexOf("member")) and
        cr = count(rep.indexOf("return")) and
        cp = count(rep.indexOf("parameter")) and
        cpr = count(rep.indexOf("parameter -1")) and
        croot = count(rep.indexOf("(root ")) and
        (
          asRhs = true and
          cm = 1 and
          cr = 1 and
          cp = 1 and
          croot = 1 and
          cpr = 0 and
          plus = 50
          or
          asRhs = true and
          cm = 1 and
          cr = 1 and
          cp = 1 and
          cpr = 0 and
          plus = 150
          or
          plus = 0
        ) and
        // Penalizes the receivers againts members
        score = cm * 4 + cr * 3 + cp * 5 - cpr * 8 + plus
      )
    |
      rep order by score, depth, rep
    )
}

string selectBestRep(DataFlow::Node sink, boolean asRhs) {
  exists(string rep, int score, int depth |
  result = rep and rep  = candidateRep(sink, depth, asRhs) 
    and score = count (  rep.indexOf("member"))*6
    +  count (  rep.indexOf("return"))*3
    +  count (  rep.indexOf("parameter"))*5
    // Penalizes the receivers againts members
    -  count (  rep.indexOf("parameter -1"))*9
    and score > 3 and depth>=1
  )
}

