import javascript

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
    m.(ES2015Module).exports("default", result.(DataFlow::ValueNode).getAstNode())
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
  // the global object
  isRelevant(nd) and
  nd = DataFlow::globalObjectRef() and
  result = "(global)" and
  depth = 1
  or
  // package imports/exports
  isRelevant(nd) and
  exists(string pkg |
    nd = DataFlow::moduleImport(pkg) and
    // avoid picking up local imports
    pkg.regexpMatch("[^./].*")
    or
    nd = getAnExport(pkg).getALocalSource()
  |
    result = "(root https://www.npmjs.com/package/" + pkg + ")" and
    depth = 1
  )
  or
  // compound representations
  exists(DataFlow::SourceNode base, string step, string baserep |
    (
      baserep = candidateRep(base, depth - 1) and
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
      nd = base.getAPropertyRead(prop)
      or
      nd = base.getAPropertyWrite(prop).getRhs().getALocalSource()
    |
      step = "member " + prop
    )
    or
    // instances
    (
      nd = base.getAnInstantiation()
      or
      nd = base.(DataFlow::ClassNode).getAnInstanceReference()
    ) and
    step = "instance"
    or
    // parameters
    exists(string p |
      exists(int i |
        nd = base.(DataFlow::FunctionNode).getParameter(i) or
        nd = base.(DataFlow::InvokeNode).getArgument(i)
      |
        p = i.toString()
      )
      or
      nd = base.(DataFlow::FunctionNode).getAParameter() and
      p = nd.(DataFlow::ParameterNode).getName()
    |
      step = "parameter " + p
    )
    or
    // return values
    (
      nd = base.(DataFlow::FunctionNode).getAReturn().getALocalSource()
      or
      nd = base.getAnInvocation()
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
    depth = 2
  )
  or
  // global variables, which are treated as members of the global object
  isRelevant(nd) and
  exists(string g |
    nd = DataFlow::globalVarRef(g)
    or
    exists(AssignExpr assgn |
      assgn.getLhs() = DataFlow::globalVarRef(g).asExpr() and
      nd = assgn.getRhs().flow().getALocalSource()
    )
  |
    result = "(member " + g + " (global))" and
    depth = 2
  )
  or
  // we ignore `await`
  exists(DataFlow::SourceNode base |
    base.flowsToExpr(nd.asExpr().(AwaitExpr).getOperand()) and
    result = candidateRep(base, depth)
  )
}
