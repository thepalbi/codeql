import javascript
import NodeRepresentation

module PropagationGraph {
/**
 * Gets the minimum number of ocurrences of a candidate representation.
 *
 * Reducing this bound will generate more candidate representations, but
 * will generally negatively affect performance. 
 */
private int minOcurrences() { result = 1 }


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
        (
          taintStep(nd, _)
          or
          guard(nd, _)
        )
        or
        nd instanceof DataFlow::PropRead
        or
        nd instanceof DataFlow::ParameterNode and
        taintStep(nd, _)
        or
        exists(DataFlow::InvokeNode invk | not calls(invk, _) |
          nd = invk.getAnArgument()
          or
          nd = invk.(DataFlow::MethodCallNode).getReceiver()
        ) and
        (taintStep(_, nd) or nd instanceof DataFlow::PropRead)
      ) and
      isRelevant(nd)
    }

  /**
   * Holds if `pred` is a call of the form `f(..., x, ...)` and `succ` is a subsequent
   * use of `x` where the result of the call is either known to be true or known to be
   * false.
   */
  private predicate guard(DataFlow::CallNode pred, DataFlow::Node succ) {
    exists(ConditionGuardNode g, SsaVariable v |
      g.getTest() = pred.asExpr() and
      pred.getAnArgument().asExpr() = v.getAUse() and
      succ.asExpr() = v.getAUse() and
      exists(MkNode(succ)) and
      g.dominates(succ.getBasicBlock())
    )
  }

  /**
   * A propagation-graph node, or "event" in Merlin terminology (cf Section 5.1 of
   * Seldon paper).
   */
   class Node extends TNode {
    DataFlow::Node nd;

    Node() { this = MkNode(nd) }

    predicate isSourceCandidate() {
      exists(candidateRep(false)) and
      (
        nd instanceof DataFlow::CallNode or
        nd instanceof DataFlow::PropRead or
        nd instanceof DataFlow::ParameterNode
      )
    }

    predicate isSanitizerCandidate() {
      exists(candidateRep(false)) and nd instanceof DataFlow::CallNode
    }

    predicate isSinkCandidate() {
      exists(candidateRep(true)) and
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

    string candidateRep(boolean asRhs) { result = candidateRep(nd, _, asRhs) }


      /**
      * Choose one repr for a sink
      * Prioritizes the use of member instead of receivers
      */
      string chooseBestRep(DataFlow::Node sink, boolean asRhs) {
        result = max(string rep, int depth, int score | 
          rep = candidateRep(sink, depth, asRhs) 
          and score = count (  rep.indexOf("member"))*4
          +  count (  rep.indexOf("return"))*2
          +  count (  rep.indexOf("parameter"))*3
          // Penalizes the receivers againts members
          -  count (  rep.indexOf("parameter -1"))*4
          | rep order by score, depth, rep) 
      }

      string selectBestRep(DataFlow::Node sink, boolean asRhs) {
        exists(string rep, int score, int depth |
        result = rep and rep  = candidateRep(sink, depth, asRhs) 
          and score = count (  rep.indexOf("member"))*4
          +  count (  rep.indexOf("return"))*2
          +  count (  rep.indexOf("parameter"))*3
          // Penalizes the receivers againts members
          -  count (  rep.indexOf("parameter -1"))*4
          and score > 3 and depth>=2
        )
      }


    string rep(){
      result = this.rep(_)
        // result = candidateRep(_) and 
        // // Eliminate rare representations
        // count(Node n | n.candidateRep(_) = result) >= minOcurrences()
    }
  
    string getconcatrep(){
      result = this.getconcatrep(_)    
    }

    string getconcatrep(boolean rhs){
      result = strictconcat(string r | r = this.rep(rhs) | r, "::")
    }


    string rep1(){
        result = candidateRep(_)
    }
    /**
     * Gets an abstract representation of this node, corresponding to the REP function
     * in the Seldon paper.
     *
     * If `asRhs` is true, then this node is represented as the right-hand side of a definition,
     * otherwise as a use.
     *
     * For example, the call `foo()` in `bar(foo())` can be represented either as the first argument
     * to function `bar`, or as the result of function `foo`. If `asRhs` is true, this predicate
     * chooses the former representation, if it is false the latter.
     */
    string rep(boolean asRhs) {
      // Diego: Force only one "canonical" Repr
      //result = chooseBestRep(nd, asRhs) and
      // result = candidateRep(asRhs) and
      exists(string rep | rep  = selectBestRep(nd, asRhs) 
        and result = rep
      )
      or (
        not exists(string rep | rep  = selectBestRep(nd, asRhs))
        and result = candidateRep(asRhs) and
        count(Node n | n.candidateRep(asRhs) = result) >= minOcurrences()
        )
     }

    /**
     * Gets an abstract representation of this node, filtering out generic representations that
     * are uninteresting for inferring sources and sinks.
     *
     * See `rep` for an explanation of the `asRhs` parameter.
     */
    string preciseRep(boolean asRhs) {
      result = rep(asRhs) and
      not result.matches(genericMemberPattern())
    }

    /**
     * Holds if there is no candidate representation for this node.
     *
     * This can happen, for instance, for dynamic property reads where we
     * cannot tell the name of the property being accessed.
     */
    predicate unrepresentable() { not exists(candidateRep(_)) }

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

  class SourceCandidate extends Node {
    SourceCandidate() {
      exists(candidateRep(false)) and
      (
        nd instanceof DataFlow::InvokeNode or
        nd instanceof DataFlow::PropRead or
        nd instanceof DataFlow::ParameterNode
      )
    }

    override string rep() { result = rep(false) }

    string preciseRep() { result = preciseRep(false) }
  }

  class SanitizerCandidate extends Node {
    SanitizerCandidate() { 
      exists(candidateRep(false)) and nd instanceof DataFlow::InvokeNode
    }

    override string rep() { result = rep(false) }

    string preciseRep() { result = preciseRep(false) }
  }

  class SinkCandidate extends Node {
    SinkCandidate() {
      exists(candidateRep(true)) and
      (
        exists(DataFlow::InvokeNode invk |
          nd = invk.getAnArgument()
          or
          nd = invk.(DataFlow::MethodCallNode).getReceiver()
        )
        or
        nd = any(DataFlow::PropWrite pw).getRhs()
      )
      // and isCandidateSink(nd, _)
    }

    override string rep() { result = rep(true) }

    string preciseRep() { result = preciseRep(true) }
  }


  /**
   * Holds if there is an edge between `pred` and `succ` in the propagation graph
   * (cf Section 5.2 of Seldon paper).
   */
  predicate edge(Node pred, Node succ) {
    exists(DataFlow::CallNode c | not calls(c, _) and c = succ.asDataFlowNode() |
      pred.flowsTo(c.getAnArgument())
      or
      pred.flowsTo(c.getReceiver())
    )
    or
    pred.flowsTo(succ.asDataFlowNode()) and
    pred != succ
    or
    pointsTo(_, pred.asDataFlowNode()) = pointsTo(_, succ.asDataFlowNode()) and
    pred != succ
    or
    // edge capturing indirect flow; for example, in the code snippet
    // `if(path.isAbsolute(p)) use(p)` this adds an edge between the call to `isAbsolute`
    // and the argument `p` to `use`
    guard(pred.asDataFlowNode(), succ.asDataFlowNode())
  }

  pragma[noinline]
  private predicate callInFile(DataFlow::CallNode call, DataFlow::FunctionNode callee, File f) {
    call.getFile() = f and
    // TODO: This can be improved with TASER info. The `getACallee` candidates
    callee.getFunction() = call.getACallee(_)
  }

  /**
   * Holds if `call` calls `callee` within the same file.
   *
   * As explained in Section 5.2 of the Seldon paper, calles outside the same file are
   * not considered.
   */
  private predicate calls(DataFlow::CallNode call, DataFlow::FunctionNode callee) {
    callInFile(call, callee, callee.getFile())
  }

  /**
   * An allocation site as tracked by the points-to analysis, that is,
   * an unresolvable call, or a parameter to a callback function passed as an argument
   * to an unresolvable function
   */
  class AllocationSite extends DataFlow::Node {
    AllocationSite() {
      getBasicBlock() instanceof ReachableBasicBlock and
      exists(DataFlow::InvokeNode invk |
        this = invk
        or
        this = invk.getABoundCallbackParameter(_, _)
      ) or
      this instanceof LiteralObjectNode
    }
  }

  /**
   * A DataFlow::Node that matches a literal object declaration, such as:
   * ```javascript
   * const a = {};
   * ```
   */
  private class LiteralObjectNode extends DataFlow::Node {
    LiteralObjectNode() {
      this.asExpr() instanceof ObjectExpr
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

  AllocationSite allPointedBy(Node nd) {    
    result = pointsTo(_, nd.asDataFlowNode())
  }

  /** Gets the allocation sites `nd` may refer to in context `ctxt`. */
  private AllocationSite pointsTo(Context ctxt, DataFlow::Node nd) {
    result = pointsTo(ctxt, nd, _)
  }

  /** Gets the allocation sites `nd` may refer to in context `ctxt`. */
  AllocationSite pointsTo(Context ctxt, DataFlow::Node nd, string reason) {
    viableContext(ctxt, nd) and
    result = nd and reason = "circular"
    or
    result = pointsTo(ctxt, nd.getAPredecessor()) and reason = "predecessor"
    or
    exists(DataFlow::PropRead pr | nd = pr |
      result = fieldPointsTo(pointsTo(ctxt, pr.getBase()), pr.getPropertyName()) and reason = "field"
    )
    or
    // flow from the `i`th argument of a call to the corresponding parameter
    exists(DataFlow::CallNode call, DataFlow::Node arg, Context base |
      argumentPassing(call, arg, nd) and
      ctxt = push(call, base) and
      result = pointsTo(base, arg) and reason = "arguement passing"
    )
    or
    // flow from a returned value to a call to the function
    exists(DataFlow::FunctionNode callee |
      calls(nd, callee) and
      viableContext(ctxt, nd) and
      result = pointsTo(push(nd, ctxt), callee.getAReturn()) and reason = "return"
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

  string getconcatrep(DataFlow::Node n, boolean asRhs){
    result = strictconcat(string r | r = candidateRep(n, _, asRhs) and exists(PropagationGraph::Node nd | nd.rep(asRhs) = r)  | r, "::")
  }

  string getconcatrep(DataFlow::Node n){
    result = getconcatrep(n, _)
  }
}
