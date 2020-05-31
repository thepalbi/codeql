from abc import ABC
from enum import Enum


class Constraint(Enum):
    LTE=1
    GTE=2
    LT=3
    GT=4


def print(lhs:str, rhs:str, constraint_type: Constraint):
    if constraint_type == Constraint.LTE:
        return "{0} - {1}".format(lhs, rhs.replace(" + ", " - "))
    elif constraint_type == Constraint.GTE:
        return "{1} - {0}".format(lhs, rhs.replace(" + ", " - "))