from pyparsing import Word, alphas, alphanums, infixNotation, nums, Optional, Literal
from fourFn import BNF
import simpleArith

class ConstraintParser:
    def __init__(self):
        self.pattern = simpleArith.expr

    def parse(self, expr):
        return self.pattern.parseString(expr)


