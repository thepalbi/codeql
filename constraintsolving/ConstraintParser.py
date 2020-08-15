class ConstraintParser:
    def __init__(self):
        self.pattern = simpleArith.expr

    def parse(self, expr):
        return self.pattern.parseString(expr)


