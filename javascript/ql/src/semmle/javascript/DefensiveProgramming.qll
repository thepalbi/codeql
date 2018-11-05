/**
 * Provides classes for working with defensive programming patterns.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * A test in a defensive programming pattern.
 */
abstract class DefensiveExpressionTest extends DataFlow::ValueNode {
  /** Gets the unique Boolean value that this test evaluates to, if any. */
  abstract boolean getTheTestResult();
}

/**
 * INTERNAL: Do not use directly; use `DefensiveExpressionTest` instead.
 */
module Internal {
  /**
   * A defensive truthiness check that may be worth keeping, even if it
   * is strictly speaking useless.
   *
   * We currently recognize three patterns:
   *
   *   - the first `x` in `x || (x = e)`
   *   - the second `x` in `x = (x || e)`
   *   - the second `x` in `var x = x || e`
   */
  class DefensiveInit extends DefensiveExpressionTest {
    DefensiveInit() {
      exists(VarAccess va, LogOrExpr o, VarRef va2 |
        va = astNode and
        va = o.getLeftOperand().stripParens() and va2.getVariable() = va.getVariable() |
        exists(AssignExpr assgn | va2 = assgn.getTarget() |
          assgn = o.getRightOperand().stripParens() or
          o = assgn.getRhs().stripParens()
        )
        or
        exists(VariableDeclarator vd | va2 = vd.getBindingPattern() | o = vd.getInit().stripParens())
      )
    }

    override boolean getTheTestResult() {
      result = analyze().getTheBooleanValue()
    }
  }

  /**
   * Gets the inner expression of `e`, with any surrounding parentheses and boolean nots removed.
   * `polarity` is true iff the inner expression is nested in an even number of negations.
   */
  private Expr stripNotsAndParens(Expr e, boolean polarity) {
    exists (Expr inner |
      inner = e.getUnderlyingValue() |
      if inner instanceof LogNotExpr then
        (result = stripNotsAndParens(inner.(LogNotExpr).getOperand(), polarity.booleanNot()))
      else
        (result = inner and polarity = true)
    )
  }

  /**
   * An equality test for `null` and `undefined`.
   */
  private abstract class UndefinedNullTest extends EqualityTest {
    /** Gets the unique Boolean value that this test evaluates to, if any. */
    abstract boolean getTheTestResult();

    /**
     * Gets the expression that is tested for being `null` or `undefined`.
     */
    abstract Expr getOperand();
  }

  /**
   * A dis- or conjunction that tests if an expression is `null` or `undefined` in either branch.
   */
  private class CompositeUndefinedNullTestPart extends DefensiveExpressionTest {

    UndefinedNullTest test;

    boolean polarity;

    CompositeUndefinedNullTestPart(){
      exists (LogicalBinaryExpr composite, Variable v, Expr op, Expr opOther, UndefinedNullTest testOther |
        composite.hasOperands(op, opOther) and
        this = op.flow() and
        test = stripNotsAndParens(op, polarity) and
        testOther = stripNotsAndParens(opOther, _) and
        test.getOperand().(VarRef).getVariable() = v and
        testOther.getOperand().(VarRef).getVariable() = v
      )
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * A test for `undefined` or `null` in an if-statement.
   */
  private class SanityCheckingUndefinedNullGuard extends DefensiveExpressionTest {

    UndefinedNullTest test;

    boolean polarity;

    SanityCheckingUndefinedNullGuard() {
      exists (IfStmt c |
        this = c.getCondition().flow() and
        test = stripNotsAndParens(c.getCondition(), polarity) and
        test.getOperand() instanceof VarRef
      )
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * Holds if `t` is `null` or `undefined`.
   */
  private predicate isNullOrUndefined(InferredType t) {
    t = TTNull() or
    t = TTUndefined()
  }

  /**
   * Holds if `t` is not `null` or `undefined`.
   */
  private predicate isNotNullOrUndefined(InferredType t) {
    not isNullOrUndefined(t)
  }

  /**
   * A value comparison for `null` and `undefined`.
   */
  private class NullUndefinedComparison extends UndefinedNullTest {

    Expr operand;

    InferredType op2type;

    NullUndefinedComparison() {
      exists (Expr op2 |
        hasOperands(operand, op2) |
        op2type = TTNull() and SyntacticConstants::isNull(op2)
        or
        op2type = TTUndefined() and SyntacticConstants::isUndefined(op2)
      )
    }

    override boolean getTheTestResult() {
      result = getPolarity() and
      (
        if this instanceof StrictEqualityTest then
          // case: `operand === null` or `operand === undefined`
          operand.analyze().getTheType() = op2type
        else
          // case: `operand == null` or `operand == undefined`
          not isNotNullOrUndefined(operand.analyze().getAType())
      )
      or
      result = getPolarity().booleanNot() and
      (
        if this instanceof StrictEqualityTest then
          // case: `operand !== null` or `operand !== undefined`
          not operand.analyze().getAType() = op2type
        else
          // case: `operand != null` or `operand != undefined`
          not isNullOrUndefined(operand.analyze().getAType())
      )
    }

    override Expr getOperand() {
      result = operand
    }
  }

  /**
   * An expression that throws an exception if one of its subexpressions evaluates to `null` or `undefined`.
   */
  private class UndefinedNullCrashUse extends Expr {

    Expr target;

    UndefinedNullCrashUse() {
      this.(InvokeExpr).getCallee().getUnderlyingValue() = target
      or
      this.(PropAccess).getBase().getUnderlyingValue() = target
      or
      this.(MethodCallExpr).getReceiver().getUnderlyingValue() = target
    }

    /**
     * Gets the subexpression that will cause an exception to be thrown if it is `null` or `undefined`.
     */
    Expr getVulnerableSubexpression() {
      result = target
    }

  }

  /**
   * An expression that throws an exception if one of its subexpressions is not a `function`.
   */
  private class NonFunctionCallCrashUse extends Expr {

    Expr target;

    NonFunctionCallCrashUse() {
      this.(InvokeExpr).getCallee().getUnderlyingValue() = target
    }

    /**
     * Gets the subexpression that will cause an exception to be thrown if it is not a `function`.
     */
    Expr getVulnerableSubexpression() {
      result = target
    }

  }

  /**
   * Gets the first expression that is guarded by `guard`.
   */
  private Expr getAGuardedExpr(Expr guard) {
    exists(LogicalBinaryExpr op |
      op.getLeftOperand() = guard and
      op.getRightOperand() = result
    )
    or
    exists(IfStmt c |
      c.getCondition() = guard |
      result = c.getAControlledStmt().getChildExpr(0) or
      result = c.getAControlledStmt().(BlockStmt).getStmt(0).getChildExpr(0)
    )
    or
    exists (ConditionalExpr c |
      c.getCondition() = guard |
      result = c.getABranch()
    )
  }

  /**
   * Holds if `t` is `string`, `number` or `boolean`.
   */
  private predicate isStringOrNumOrBool(InferredType t) {
    t = TTString() or
    t = TTNumber() or
    t = TTBoolean()
  }

  /**
   * A defensive expression that tests for `undefined` and `null` using a truthiness test.
   */
  private class UndefinedNullTruthinessGuard extends DefensiveExpressionTest {

    VarRef guardVar;

    boolean polarity;

    UndefinedNullTruthinessGuard() {
      exists (VarRef useVar |
        guardVar = stripNotsAndParens(this.asExpr(), polarity) and
        guardVar.getVariable() = useVar.getVariable() |
        getAGuardedExpr(this.asExpr()).getUnderlyingValue().(UndefinedNullCrashUse).getVulnerableSubexpression() = useVar and
        // exclude types whose truthiness depend on the value
        not isStringOrNumOrBool(guardVar.analyze().getAType())
      )
    }

    override boolean getTheTestResult() {
      exists (boolean testResult |
        testResult = guardVar.analyze().getTheBooleanValue() |
        if polarity = true then
          result = testResult
        else
          result = testResult.booleanNot()
      )
    }

  }

  /**
   * A defensive expression that tests for `undefined` and `null`.
   */
  private class UndefinedNullTypeGuard extends DefensiveExpressionTest {

    UndefinedNullTest test;

    boolean polarity;

    UndefinedNullTypeGuard() {
      exists (Expr guard, VarRef guardVar, VarRef useVar |
        this = guard.flow() and
        test = stripNotsAndParens(guard, polarity) and
        test.getOperand() = guardVar and
        guardVar.getVariable() = useVar.getVariable() |
        getAGuardedExpr(guard).getUnderlyingValue().(UndefinedNullCrashUse).getVulnerableSubexpression() = useVar
      )
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * A test for the value of a `typeof` expression.
   */
  private class TypeofTest extends EqualityTest {
    Expr operand;

    TypeofTag tag;

    TypeofTest() {
      exists (Expr op1, Expr op2 |
        hasOperands(op1, op2) |
        operand = op1.(TypeofExpr).getOperand() and
        op2.mayHaveStringValue(tag)
      )
    }

    boolean getTheTestResult() {
      exists (boolean testResult |
        testResult = true and operand.analyze().getTheType().getTypeofTag() = tag or
        testResult = false and not operand.analyze().getAType().getTypeofTag() = tag |
        if getPolarity() = true then
          result = testResult
        else
          result = testResult.booleanNot()
      )
    }

    /**
     * Gets the operand used in the `typeof` expression.
     */
    Expr getOperand() {
      result = operand
    }

    /**
     * Gets the `typeof` tag that is tested.
     */
    TypeofTag getTag() {
      result = tag
    }
  }

  /**
   * A defensive expression that tests if an expression has type `function`.
   */
  private class FunctionTypeGuard extends DefensiveExpressionTest {

    TypeofTest test;

    boolean polarity;

    FunctionTypeGuard() {
      exists (Expr guard, VarRef guardVar, VarRef useVar |
        this = guard.flow() and
        test = stripNotsAndParens(guard, polarity) and
        test.getOperand() = guardVar and
        guardVar.getVariable() = useVar.getVariable() |
        getAGuardedExpr(guard).getUnderlyingValue().(NonFunctionCallCrashUse).getVulnerableSubexpression() = useVar
      ) and
      test.getTag() = "function"
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * A test for `undefined` using a `typeof` expression.
   */
  class TypeofUndefinedTest extends UndefinedNullTest {

    TypeofTest test;

    TypeofUndefinedTest() {
      this = test and
      test.getTag() = "undefined"
    }

    override boolean getTheTestResult() {
      result = test.getTheTestResult()
    }

    override Expr getOperand() {
      result = test.getOperand()
    }

  }

}