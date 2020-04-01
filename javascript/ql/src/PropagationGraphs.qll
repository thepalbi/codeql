/**
 * @kind graph
 */

import javascript

module PropagationGraph {
  /**
   * A propagation-graph node, or "event" in Merlin terminology (cf Section 5.1 of
   * Seldon paper).
   */
  class Node extends DataFlow::Node {
    Node() {
      (
        this instanceof DataFlow::InvokeNode
        or
        this instanceof DataFlow::PropRead
        or
        this instanceof DataFlow::ParameterNode
        or
        exists(DataFlow::InvokeNode invk |
          this = invk.(DataFlow::MethodCallNode).getReceiver() or
          this = invk.getAnArgument()
        )
      ) and
      // exclude externs files (i.e., our manually-written API models) and ambient files (such as
      // TypeScript `.d.ts` files); there is no real data flow going on in those
      not this.getTopLevel().isExterns() and
      not this.getTopLevel().isAmbient()
    }

    predicate flowsTo(DataFlow::Node sink) {
      this = sink or this.(DataFlow::SourceNode).flowsTo(sink)
    }
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
    base = Top() and
    result = Call(c)
    or
    base = Call(_) and
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
