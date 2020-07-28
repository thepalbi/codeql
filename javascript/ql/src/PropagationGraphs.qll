/**
 * @kind graph
 */

import javascript

module PropagationGraph {
  /**
   * A taint step for purposes of the propagation graph.
   *
   * This includes both standard (local) taint steps and an additional step from
   * a tainted property to the enclosing object. This step is not included among
   * the standard taint steps since it would lead to false flow in combination with
   * the converse step from tainted objects to their properties. For propagation graphs,
   * on the other hand, we are less worried about false positives than about false
   * negatives, so we include both steps.
   */
  private predicate taintStep(DataFlow::Node pred, DataFlow::Node succ) {
    TaintTracking::localTaintStep(pred, succ)
    or
    succ.(DataFlow::SourceNode).hasPropertyWrite(_, pred)
  }

  private predicate isRelevant(DataFlow::Node nd) {
    // exclude externs files (i.e., our manually-written API models) and ambient files (such as
    // TypeScript `.d.ts` files); there is no real data flow going on in those
    not nd.getTopLevel().isExterns() and
    not nd.getTopLevel().isAmbient() and
    nd.getBasicBlock() instanceof ReachableBasicBlock
  }

  private newtype TNode =
    MkNode(DataFlow::Node nd) {
      (
        nd instanceof DataFlow::InvokeNode and
        taintStep(nd, _)
        or
        nd instanceof DataFlow::PropRead and
        taintStep(nd, _)
        or
        nd instanceof DataFlow::ParameterNode and
        taintStep(nd, _)
        or
        exists(DataFlow::InvokeNode invk | not calls(invk, _) |
          nd = invk.getAnArgument()
          or
          nd = invk.(DataFlow::MethodCallNode).getReceiver()
        ) and
        taintStep(_, nd)
      ) and
      isRelevant(nd)
    }

  /**
   * A propagation-graph node, or "event" in Merlin terminology (cf Section 5.1 of
   * Seldon paper).
   */
  class Node extends TNode {
    DataFlow::Node nd;

    Node() { this = MkNode(nd) }

    predicate isSourceCandidate() {
      exists(candidateRep()) and
      (
        nd instanceof DataFlow::CallNode or
        nd instanceof DataFlow::PropRead or
        nd instanceof DataFlow::ParameterNode
      )
    }

    predicate isSanitizerCandidate() {
      exists(candidateRep()) and nd instanceof DataFlow::CallNode
    }

    predicate isSinkCandidate() {
      exists(candidateRep()) and
      (
        exists(DataFlow::InvokeNode invk |
          nd = invk.getAnArgument()
          or
          nd = invk.(DataFlow::MethodCallNode).getReceiver()
        )
        or
        nd = any(DataFlow::PropWrite pw).getRhs()
      )
    }

    private string candidateRep() { result = candidateRep(nd, _) }

    string rep1(){
        result = candidateRep()
    }
    /**
     * Gets an abstract representation of this node, corresponding to the REP function
     * in the Seldon paper.
     */
    string rep() {
      result = candidateRep() and
      // eliminate rare representations
      count(Node n | n.candidateRep() = result) >= 1
    }

    string getconcatrep(){
        result = strictconcat(string r | r = this.rep() | r, "::")
    }

    /**
     * Holds if there is no candidate representation for this node.
     *
     * This can happen, for instance, for dynamic property reads where we
     * cannot tell the name of the property being accessed.
     */
    predicate unrepresentable() { not exists(candidateRep()) }

    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      nd.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    string toString() { result = nd.toString() }
    // string toString() { result = rep() }

    predicate flowsTo(DataFlow::Node sink) {
      nd = sink
      or
      nd instanceof DataFlow::SourceNode and
      taintStep*(nd, sink)
    }

    DataFlow::Node asDataFlowNode() { result = nd }
  }

  /**
   * Holds if there is an edge between `pred` and `succ` in the propagation graph
   * (cf Section 5.2 of Seldon paper).
   */
  predicate edge(Node pred, Node succ) {
    exists(DataFlow::CallNode c | not calls(c, _) and c = succ.asDataFlowNode() |
      pred.flowsTo(c.getAnArgument())
    )
    or
    pred.flowsTo(succ.asDataFlowNode()) and
    pred != succ
    or
    exists(ObjectExpr obj | obj.flow() = succ.asDataFlowNode() |
      pred.flowsTo(obj.getAProperty().getInit().flow())
    )
    or
    pred.flowsTo(succ.asDataFlowNode().(DataFlow::ArrayLiteralNode).getAnElement())
    or
    pointsTo(_, pred.asDataFlowNode()) = pointsTo(_, succ.asDataFlowNode()) and
    pred != succ
  }

  /**
   * Holds if `call` calls `callee` within the same file.
   *
   * As explained in Section 5.2 of the Seldon paper, calles outside the same file are
   * not considered.
   */
  private predicate calls(DataFlow::CallNode call, DataFlow::FunctionNode callee) {
    callee = call.getACallee(_).flow() and
    callee.getFile() = call.getFile()
  }

  /**
   * An allocation site as tracked by the points-to analysis, that is,
   * an unresolvable call.
   */
  private class AllocationSite extends DataFlow::InvokeNode {
    AllocationSite() {
      getBasicBlock() instanceof ReachableBasicBlock and
      not calls(this, _)
    }
  }

  /** A (1-CFA) context. */
  private newtype Context =
    Top() or
    Call(DataFlow::CallNode c) { not c instanceof AllocationSite }

  /** Gets the context resulting from adding call site `c` to context `base`. */
  private Context push(DataFlow::CallNode c, Context base) {
    base = any(Context ctxt) and
    result = Call(c)
  }

  /** Holds if `nd` should be analyzed in context `ctxt`. */
  private predicate viableContext(Context ctxt, DataFlow::Node nd) {
    ctxt = Top() and
    nd.getBasicBlock() instanceof ReachableBasicBlock
    or
    exists(DataFlow::CallNode c, DataFlow::FunctionNode fn |
      calls(c, fn) and
      fn.getFunction() = nd.getContainer() and
      nd.getBasicBlock() instanceof ReachableBasicBlock and
      ctxt = Call(c)
    )
  }

  private predicate argumentPassing(DataFlow::CallNode call, DataFlow::Node arg, DataFlow::Node parm) {
    exists(DataFlow::FunctionNode callee | calls(call, callee) |
      exists(int i |
        arg = call.getArgument(i) and
        parm = callee.getParameter(i)
      )
      or
      arg = call.getReceiver() and
      parm = callee.getReceiver()
    )
  }

  /** Gets the allocation sites `nd` may refer to in context `ctxt`. */
  private AllocationSite pointsTo(Context ctxt, DataFlow::Node nd) {
    viableContext(ctxt, nd) and
    result = nd
    or
    result = pointsTo(ctxt, nd.getAPredecessor())
    or
    exists(DataFlow::PropRead pr | nd = pr |
      result = fieldPointsTo(pointsTo(ctxt, pr.getBase()), pr.getPropertyName())
    )
    or
    // flow from the `i`th argument of a call to the corresponding parameter
    exists(DataFlow::CallNode call, DataFlow::Node arg, Context base |
      argumentPassing(call, arg, nd) and
      ctxt = push(call, base) and
      result = pointsTo(base, arg)
    )
    or
    // flow from a returned value to a call to the function
    exists(DataFlow::FunctionNode callee |
      calls(nd, callee) and
      viableContext(ctxt, nd) and
      result = pointsTo(push(nd, ctxt), callee.getAReturn())
    )
  }

  /** Gets an allocation site field `f` of allocation site `a` may point to. */
  private AllocationSite fieldPointsTo(AllocationSite a, string f) {
    exists(DataFlow::PropWrite pw, Context ctxt |
      fieldWriteBasePointsTo(ctxt, pw, f, a) and
      result = pointsTo(ctxt, pw.getRhs())
    )
  }

  /** Holds if `pw` is a property write to field `f` and its base may point to `a`. */
  private predicate fieldWriteBasePointsTo(
    Context ctxt, DataFlow::PropWrite pw, string f, AllocationSite a
  ) {
    a = pointsTo(ctxt, pw.getBase()) and
    f = pw.getPropertyName()
  }

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
   * Gets the maximum depth of a candidate representation.
   *
   * Increasing this bound will generate more candidate representations, but
   * will generally negatively affect performance. Note that rare candidates are
   * are filtered out above, so increasing the bound beyond a certain threshold may
   * not actually yield new candidates.
   */
  private int maxdepth() {
    result = 5
  }

  /**
   * Gets a candidate representation of `nd` as a (suffix of an) access path.
   */
  private string candidateRep(DataFlow::Node nd, int depth) {
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
}
