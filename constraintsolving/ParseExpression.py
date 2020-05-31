# from parsimonious.grammar import Grammar
# from parsimonious.nodes import NodeVisitor
from lark import Lark, Transformer, v_args, Visitor
import tensorflow as tf
# grammar = Grammar(
#     """
#     expression = factor (addop factor)*
#     mulop =  ("*" _) / ("/" _)
#     factor = ('('  factor  ')') / (term (mulop / addop) term)*)
#     addop = ("+" _) / ("-" _)
#     term = number / id
#     id = ~"[a-zA-Z_0-9]+" _
#     number = ~"[0-9.]+" _
#     _ = meaninglessness*
#     meaninglessness = ~r"\s+"
#     """
# )

#print(grammar.parse("(n842_san+n722_san)/2 + (n389_snk+n369_snk)/2"))

calc_grammar = """
    ?start: sum
          | NAME "=" sum    -> assign_var
    ?sum: product
        | sum "+" product   -> add
        | sum "-" product   -> sub
    ?product: atom
        | product "*" atom  -> mul
        | product "/" atom  -> div
    ?atom: NUMBER           -> number
         | "-" atom         -> neg
         | NAME             -> var
         | "(" sum ")"      -> brackets
    %import common.CNAME -> NAME
    %import common.NUMBER
    %import common.WS_INLINE
    %ignore WS_INLINE
"""

@v_args(inline=True)
class ParseExpression(Transformer):
    def __init__(self, vars, format='tf'):
        super().__init__()
        self.vars = vars
        self.parser = Lark(calc_grammar, parser='lalr', transformer=self)
        self.computed_expression = None
        self.format=format

    def parse(self, expression):
        return self.parser.parse(expression)

    def brackets(self, arg):
        return arg

    def number(self, tree):
        if self.format == 'tf':
            return tf.constant(float(str(tree)), dtype=tf.float32)
        else:
            return float(str(tree))

    def var(self, tree):
        return self.vars[str(tree)]

    def sub(self, t0, t1):
        return t0 - t1

    def mul(self, t0, t1):
        return t0 * t1

    def div(self, t0, t1):
        try:
            return t0 / t1
        except:
            return None

    def add(self, t0, t1):
        return t0 + t1

def getParser():
    calc_parser = Lark(calc_grammar, parser='lalr')
    return calc_parser.parse

#p=ParseExpression([])
#p.parse("a+b")
# calc_parser = Lark(calc_grammar, parser='lalr')
# ParseExpression().visit(calc_parser.parse("(n399_san+n668_san)/2 + (n83_snk+n254_snk+n368_snk+n308_snk)/4 - (n1015_src+n253_src+n1008_src+n517_src+n379_src+n344_src+n93_src+n733_src+n890_src+n277_src+n513_src+n14_src+n33_src+n138_src+n489_src)/15 - 0.75 - eps_9"))
#print(calc("123 + 5"))

