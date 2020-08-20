import javascript
import NodeRepresentation

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
      count(Node n | n.candidateRep() = result) >= 5
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

    string getKind() {
      if nd = DataFlow::reflectiveCallNode(_)
      then result = "reflective call"
      else
        if nd instanceof DataFlow::InvokeNode
        then result = "explicit call"
        else
          if nd instanceof DataFlow::PropRead
          then result = "read"
          else
            if nd instanceof DataFlow::ParameterNode
            then result = "param"
            else result = "other"
    }

    /** Gets a unique ID for this propagation-graph node, consisting of its URL and its kind. */
    string getId() {
      exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
        hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
        result =
          filepath + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn + ";" +
            getKind()
      )
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

  string getconcatrep(DataFlow::Node n){
    result = strictconcat(string r | r = candidateRep(n, _) and exists(PropagationGraph::Node nd | nd.rep() = r)  | r, "::")
  }
}
