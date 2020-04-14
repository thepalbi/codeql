/**
 * @kind graph
 */

import javascript
private import semmle.javascript.dataflow.Portals

module PropagationGraph {
  /**
   * A propagation-graph node, or "event" in Merlin terminology (cf Section 5.1 of
   * Seldon paper).
   */
  class Node extends DataFlow::SourceNode {
    Node() {
      (
        this instanceof DataFlow::InvokeNode
        or
        this instanceof DataFlow::PropRead
        or
        this instanceof DataFlow::ParameterNode
      ) and
      // exclude externs files (i.e., our manually-written API models) and ambient files (such as
      // TypeScript `.d.ts` files); there is no real data flow going on in those
      not this.getTopLevel().isExterns() and
      not this.getTopLevel().isAmbient()
    }

    /**
     * Gets a candidate representation of this node as a (suffix of an) access path.
     */
    private string candidateRep() {
      exists(Portal p | this = p.getAnExitNode(_) |
        exists(int i, string prefix |
          prefix = p.getBasePortal(i).toString() and
          result = p.toString().replaceAll(prefix, "*") and
          // ensure the suffix isn't entirely composed of `parameter` and `return` steps
          result.regexpMatch(".*\\((global|member|root).*")
        )
        or
        result = p.toString()
      )
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

    /**
     * Holds if there is no candidate representation for this node.
     *
     * This can happen, for instance, for parameters of purely local functions.
     */
    predicate unrepresentable() {
      not exists(candidateRep())
    }

    override string toString() { result = rep() }
  }

  /**
   * Holds if there is an edge between `pred` and `succ` in the propagation graph
   * (cf Section 5.2 of Seldon paper).
   */
  predicate edge(Node pred, Node succ) {
    exists(DataFlow::CallNode c | c = succ | pred.flowsTo(c.getAnArgument()))
    or
    exists(ObjectExpr obj | obj.flow() = succ | pred.flowsTo(obj.getAProperty().getInit().flow()))
    or
    pred.flowsTo(succ.(DataFlow::ArrayLiteralNode).getAnElement())
    or
    // pointsTo(_, pred) = pointsTo(_, succ) and
    pred = pointsTo(_, succ) and
    pred != succ
  }

  /**
   * Holds if `call` calls `callee` within the same file.
   *
   * As explained in Section 5.2 of the Seldon paper, calles outside the same file are
   * not considered.
   */
  private predicate calls(DataFlow::CallNode call, DataFlow::FunctionNode callee) {
    callee = call.getACallee().flow() and
    callee.getFile() = call.getFile()
  }

  /**
   * An allocation site as tracked by the points-to analysis, that is,
   * an unresolvable call.
   */
  private class AllocationSite extends DataFlow::InvokeNode {
    AllocationSite() { not calls(this, _) }
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
    ctxt = Top()
    or
    exists(DataFlow::CallNode c, DataFlow::FunctionNode fn |
      calls(c, fn) and
      fn.getFunction() = nd.getContainer() and
      ctxt = Call(c)
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
    exists(DataFlow::CallNode call, DataFlow::FunctionNode callee | calls(call, callee) |
      // flow from the `i`th argument of a call to the corresponding parameter
      exists(int i, Context base |
        nd = callee.getParameter(i) and
        ctxt = push(call, base) and
        result = pointsTo(base, call.getArgument(i))
      )
      or
      // flow from the receiver of a method call to the `this` value of the callee
      exists(Context base |
        nd = callee.getReceiver() and
        ctxt = push(call, base) and
        result = pointsTo(base, call.getReceiver())
      )
      or
      // flow from a returned value to a call to the function
      nd = call and
      viableContext(ctxt, nd) and
      result = pointsTo(push(call, ctxt), callee.getAReturn())
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
}
