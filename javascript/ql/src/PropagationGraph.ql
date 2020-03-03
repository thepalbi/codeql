/**
 * @kind graph
 */

import javascript

module PropagationGraph {
  class Node extends DataFlow::Node {
    Node() {
      this instanceof DataFlow::InvokeNode or
      this instanceof DataFlow::PropRead or
      this instanceof DataFlow::ParameterNode or
      exists(DataFlow::InvokeNode invk |
        this = invk.(DataFlow::MethodCallNode).getReceiver() or
        this = invk.getAnArgument()
      )
    }

    predicate flowsTo(DataFlow::Node sink) {
      this = sink or this.(DataFlow::SourceNode).flowsTo(sink)
    }
  }

  predicate edge(Node pred, Node succ) {
    exists(DataFlow::CallNode c | c = succ |
      //not c instanceof DataFlow::MethodCallNode and
      pred.flowsTo(c.getAnArgument())
    )
    or
    exists(ObjectExpr obj | obj.flow() = succ | pred.flowsTo(obj.getAProperty().getInit().flow()))
    or
    pred.flowsTo(succ.(DataFlow::ArrayLiteralNode).getAnElement())
    or
    pred = pointsTo(_, succ)
  }

  class AllocationSite extends DataFlow::InvokeNode {
    AllocationSite() {
      not exists(getACallee()) or
      getACallee().getFile() != this.getFile()
    }
  }

  predicate calls(DataFlow::MethodCallNode call, DataFlow::FunctionNode callee) {
    callee = call.getACallee().flow() and
    callee.getFile() = call.getFile()
  }

  newtype Context =
    Top() or
    Call(DataFlow::MethodCallNode c) { not c instanceof AllocationSite }

  Context push(DataFlow::MethodCallNode c, Context base) {
    base = Top() and
    result = Call(c)
    or
    base = Call(_) and
    result = Call(c)
  }

  predicate viableContext(Context ctxt, DataFlow::Node nd) {
    ctxt = Top()
    or
    exists(DataFlow::MethodCallNode c, DataFlow::FunctionNode fn |
      calls(c, fn) and
      fn.getFunction() = nd.getContainer() and
      ctxt = Call(c)
    )
  }

  AllocationSite pointsTo(Context ctxt, DataFlow::Node nd) {
    viableContext(ctxt, nd) and
    result = nd
    or
    result = pointsTo(ctxt, nd.getAPredecessor())
    or
    exists(DataFlow::PropRead pr | nd = pr |
      result = fieldPointsTo(ctxt, pointsTo(ctxt, pr.getBase()), pr.getPropertyName())
    )
    or
    exists(DataFlow::MethodCallNode call, DataFlow::FunctionNode callee | calls(call, callee) |
      exists(int i, Context base |
        nd = callee.getParameter(i) and
        ctxt = push(call, base) and
        result = pointsTo(base, call.getArgument(i))
      )
      or
      exists(Context base |
        nd = callee.getReceiver() and
        ctxt = push(call, base) and
        result = pointsTo(base, call.getReceiver())
      )
      or
      nd = call and
      viableContext(ctxt, nd) and
      result = pointsTo(push(call, ctxt), callee.getAReturn())
    )
  }

  AllocationSite fieldPointsTo(Context ctxt, AllocationSite a, string field) {
    exists(DataFlow::PropWrite pw |
      a = fieldWriteBasePointsTo(ctxt, pw, field) and
      result = pointsTo(ctxt, pw.getRhs())
    )
  }

  AllocationSite fieldWriteBasePointsTo(Context ctxt, DataFlow::PropWrite pw, string field) {
    viableContext(ctxt, pw) and
    result = pointsTo(ctxt, pw.getBase()) and
    field = pw.getPropertyName()
  }
}

query predicate edges(DataFlow::Node pred, DataFlow::Node succ) {
  PropagationGraph::edge(pred, succ)
}
