from enum import Enum


class Constraint(Enum):
    LTE=1
    GTE=2
    LT=3
    GT=4


def print(lhs:str, rhs:str, constraint_type: Constraint, format='gb') -> str:
    if constraint_type == Constraint.LTE:
        if format == 'gb':
            return "{0} - {1} <= 0".format(lhs, rhs.replace(" + ", " - "))
        elif format == 'norm':
            return "{0} <= {1}".format(lhs, rhs)
        else:
            return "{0} - {1}".format(lhs, rhs.replace(" + ", " - "))
    elif constraint_type == Constraint.GTE:
        if format == 'gb':
            return "{1} - {0} <= 0".format(lhs.replace(" + ", " - "), rhs)
        elif format == 'norm':
            return "{0} >= {1}".format(lhs, rhs)
        else:
            return "{1} - {0}".format(lhs.replace(" + ", " - "), rhs)