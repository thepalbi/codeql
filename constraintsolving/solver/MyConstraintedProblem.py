import re
import ast
import functools
import gurobipy as gp

import numpy as np

from .config import SolverConfig
import tensorflow_constrained_optimization as tfco
import tensorflow as tf


class TaintSpecConstraints(tfco.ConstrainedMinimizationProblem):
    def __init__(self, variables):
        from ConstraintParser import ConstraintParser
        from ParseExpression import ParseExpression
        self.vars = variables
        self.exprParser = ConstraintParser()
        self.exprParser2 = ParseExpression(self.vars)
        self.numconstraints = len([k for k in open("constraints_var.txt").readlines() if len(k) > 0] +
                                  [k for k in open("constraints_known.txt").readlines() if len(k) > 0] +
                                  [k for k in open("constraints_flow.txt").readlines() if len(k) > 0])
        #self.numconstraints = len([k for k in open("constraints_var.txt").readlines() if len(k) > 0])
        self.lambda_const = 0.1
        self._constraints=[]
        self.cache=dict()
        #self._set_constraints()

    def constraints(self):
        c = []
        print("Computing constraints...")
        self.clear_cache()
        with open("constraints_flow.txt") as constraintsfile:
            for line in constraintsfile.readlines():
                c.append(self.exprToVal(line))

        print("Computing known constraints...")
        with open("constraints_known.txt") as constraintsfile:
            for line in constraintsfile.readlines():
                res = self.exprToVal(line)
                c.append(res)

        print("Computing var constraints...")
        with open("constraints_var.txt") as constraintsfile:
            for line in constraintsfile.readlines():
                res = self.exprToVal(line)
                c.append(res)

        #self._constraints = tf.stack(c)
        return tf.stack(c)

    def clear_cache(self):
        self.cache = dict()

    def objective(self):

        # self.clear_cache()
        # print("Computing objective...")
        # with open("constraints_flow.txt") as constraintsfile:
        #     for line in constraintsfile.readlines():
        #         c.append(max(self.exprToVal(line), tf.constant(0.0, dtype=tf.float32)))
        #         #c.append(self.exprToVal(line))
        c = [self.vars[v] for v in self.vars.keys() if v.startswith("eps")]
        c2 = [self.vars[v] for v in self.vars.keys() if not v.startswith("eps")]
        # loss = gp.quicksum(c) + self.lambda_const * gp.quicksum(c2)
        loss = tf.reduce_sum(c) + self.lambda_const * tf.reduce_sum(c2)
        print("Loss: {0}".format(loss.numpy()))
        return loss

    def exprToVal(self, constraint):
        return self.exprParser2.parse(constraint.strip())

    @functools.lru_cache()
    def exprToVal2(self, constraint):
        try:
            if str(constraint) in self.cache:
                return self.cache[str(constraint)]

            if isinstance(constraint, tuple) and len(constraint) == 1:
                if re.match("^[0-9.]+$",constraint[0]):
                    val=float(constraint[0].strip())
                    res=tf.constant(val, dtype=tf.float32)
                else:
                    res=self.vars[constraint[0]]

                self.cache[str(constraint)] = res
                return res
            elif isinstance(constraint, str) and re.match("^[a-zA-Z0-9._]+$", constraint) is not None:
                if re.match("^[0-9.]+$",constraint):
                    val=float(constraint.strip())
                    res=tf.constant(val,  dtype=tf.float32)
                else:
                    res=self.vars[constraint]
                self.cache[constraint] = res
                return res
            elif isinstance(constraint, str):
                tokens = self.exprParser.parse(constraint)
                # res=self.exprToVal(tuple(tokens[0]))
                # self.cache[constraint] = res
                if isinstance(tokens[0], str):
                    res = self.exprToVal(tokens[0])
                else:
                    res = self.exprToVal(tuple(tokens[0]))
                return res
            else:
                tokens = constraint
                # if str(tokens) in self.cache:
                #     #print("cache hit")
                #     return self.cache[str(tokens)]

                # if tokens[1] == '+':
                #     result = self.exprToVal(tokens[0]) + self.exprToVal(tokens[2])
                # elif tokens[1] == '-':
                #     result = self.exprToVal(tokens[0]) - self.exprToVal(tokens[2])
                # elif tokens[1] == '*':
                #     result = self.exprToVal(tokens[0]) * self.exprToVal(tokens[2])
                # elif tokens[1] == '/':
                #     result = self.exprToVal(tokens[0]) / self.exprToVal(tokens[2])
                result = self.exprToVal(tokens[0])
                i = 1
                while i < len(tokens):
                    if tokens[i] == '+':
                        result = result + self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '-':
                        result = result - self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '*':
                        result = result * self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '/':
                        result = result / self.exprToVal(tokens[i + 1])
                    i += 2

                self.cache[str(tokens)] = result
                return result
        except:
            import traceback as tb
            tb.print_exc()
            print(constraint)

    def constraints2(self):
        # c=[]
        # print("Computing constraints...")
        # self.clear_cache()
        # with open("constraints_var.txt") as constraintsfile:
        #     for line in constraintsfile.readlines():
        #         c.append(self.exprToVal(line))
        return self._constraints

    def proxy_constraints(self):
        pass

    @property
    def num_constraints(self):
        return self.numconstraints

class GBTaintSpecConstraints:
    def __init__(self, variables, model:gp.Model, constraintsdir, config:SolverConfig):
        self.vars = variables
        self.model = model
        self.known_samples_ratio = config.known_samples_ratio
        self.exprParser = ConstraintParser()
        self.exprParser2 = ParseExpression(self.vars, format='gb')
        # self.numconstraints = len([k for k in open("constraints_var.txt").readlines() if len(k) > 0] +
        #                           [k for k in open("constraints_known.txt").readlines() if len(k) > 0] +
        #                           [k for k in open("constraints_flow.txt").readlines() if len(k) > 0])
        self.constraintsdir = constraintsdir
        self.lambda_const = config.lambda_const
        self.skip_flow_constraints = config.no_flow_constraints
        self.cache=dict()

    def clear_cache(self):
        self.cache = dict()

    def objective(self):
        c = []
        self.clear_cache()
        print("Computing objective...")
        # with open("constraints_flow.txt") as constraintsfile:
        #     for line in constraintsfile.readlines():
        #         res=self.exprToVal(line)
        #         self.model.addConstr(res >= 0)
        #         c.append(res)
        c = [self.vars[v] for v in self.vars.keys() if v.startswith("eps")]
        c2 = [self.vars[v] for v in self.vars.keys() if not v.startswith("eps")]
        loss = gp.quicksum(c) + self.lambda_const * gp.quicksum(c2)
        return loss


    def exprToVal(self, constraint):
        return self.exprParser2.parse(constraint.strip())

    def exprToVal2(self, constraint):
        try:
            if str(constraint) in self.cache:
                return self.cache[str(constraint)]

            if isinstance(constraint, list) and len(constraint) == 1:
                if re.match("^[0-9.]+$",constraint[0]):
                    val=float(constraint[0].strip())
                    res=val
                else:
                    res=self.vars[constraint[0]]

                self.cache[str(constraint)] = res
                return res
            elif isinstance(constraint, str) and re.match("^[a-zA-Z0-9._]+$", constraint) is not None:
                if re.match("^[0-9.]+$",constraint):
                    val=float(constraint.strip())
                    res=val
                else:
                    res=self.vars[constraint]
                self.cache[constraint] = res
                return res
            elif isinstance(constraint, str):
                tokens = self.exprParser.parse(constraint)
                if isinstance(tokens[0], str):
                    res = self.exprToVal(tokens[0])
                else:
                    res=self.exprToVal(list(tokens[0]))
                self.cache[constraint] = res
                return res
            else:
                tokens = constraint

                result=self.exprToVal(tokens[0])
                i=1
                while i < len(tokens):
                    if tokens[i] == '+':
                        result = result + self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '-':
                        result = result - self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '*':
                        result = result * self.exprToVal(tokens[i + 1])
                    elif tokens[i] == '/':
                        result = result / self.exprToVal(tokens[i + 1])
                    i += 2
                # if tokens[1] == '+':
                #     result = self.exprToVal(tokens[0]) + self.exprToVal(tokens[2])
                # elif tokens[1] == '-':
                #     result = self.exprToVal(tokens[0]) - self.exprToVal(tokens[2])
                # elif tokens[1] == '*':
                #     result = self.exprToVal(tokens[0]) * self.exprToVal(tokens[2])
                # elif tokens[1] == '/':
                #     result = self.exprToVal(tokens[0]) / self.exprToVal(tokens[2])

                self.cache[str(tokens)] = result
                return result
        except:
            import traceback as tb
            tb.print_exc()
            print(constraint)

    def add_constraints(self):
        self.clear_cache()
        c=1
        if not self.skip_flow_constraints:
            print("Computing flow constraints...")
            with open("{0}/constraints_flow.txt".format(self.constraintsdir)) as constraintsfile:
                for line in constraintsfile.readlines():
                    res = self.exprToVal(line)
                    self.model.addConstr(res <= 0)
                    # print("{0}".format(c), end=',')
                    c += 1
        else:
            print("Skipping flow constraints")

        print("Computing known constraints...")

        try:
            with open("{0}/constraints_known_src.txt".format(self.constraintsdir)) as constraintsfile:
                allines=constraintsfile.readlines()
                sampled=int(self.known_samples_ratio*len(allines)) if self.known_samples_ratio <= 1 else self.known_samples_ratio
                print("Sampling {0} of {1} known src constraints".format(sampled, len(allines)))
                for line in np.random.choice(allines, sampled):
                    for line_part in line.split(","):
                        if len(line_part) == 0:
                            continue
                        res = self.exprToVal(line_part)
                        self.model.addConstr(res <= 0)
                        # print("{0}-known".format(c), end=',')
                        c += 1
        except:
            print("No sources")


        try:
            with open("{0}/constraints_known_san.txt".format(self.constraintsdir)) as constraintsfile:
                allines = constraintsfile.readlines()
                sampled = int(self.known_samples_ratio * len(allines)) if self.known_samples_ratio <= 1 else self.known_samples_ratio
                print("Sampling {0} of {1} known san constraints".format(sampled, len(allines)))
                for line in np.random.choice(allines, sampled):
                    for line_part in line.split(","):
                        if len(line_part) == 0:
                            continue
                        res = self.exprToVal(line_part)
                        self.model.addConstr(res <= 0)
                        # print("{0}-known".format(c), end=',')
                        c += 1
        except:
            print("No sanitizers")

        try:
            with open("{0}/constraints_known_snk.txt".format(self.constraintsdir)) as constraintsfile:
                allines = constraintsfile.readlines()
                sampled = int(self.known_samples_ratio * len(allines)) if self.known_samples_ratio <= 1 else self.known_samples_ratio
                print("Sampling {0} of {1} known sink constraints".format(sampled, len(allines)))
                for line in np.random.choice(allines, sampled):
                    for line_part in line.split(","):
                        if len(line_part) == 0:
                            continue
                        res = self.exprToVal(line_part)
                        self.model.addConstr(res <= 0)
                        c += 1
        except:
            print("No sinks")

        # with open("{0}/constraints_candidate.txt".format(self.constraintsdir)) as constraintsfile:
        #     for line in constraintsfile.readlines():
        #         res=self.exprToVal(line)
        #         self.model.addConstr(res<=0)
        #         c += 1

        # with open("{0}/constraints_known.txt".format(self.constraintsdir)) as constraintsfile:
        #     constraints = constraintsfile.readlines()
        #     total_constraints = len(constraints)
        #     sampled = int(self.known_samples_ratio * (total_constraints / 6))
        #     indices = np.random.choice([k for k in range(len(constraints)) if k % 6 == 0], sampled)
        #     print("Sampling %g constraints out of %g" % (len(indices), total_constraints))
        #     for i in indices:
        #         for line in constraints[i:i+6]:
        #             res = self.exprToVal(line)
        #             self.model.addConstr(res <= 0)
        #             # print("{0}-known".format(c), end=',')
        #             c += 1


    def proxy_constraints(self):
        pass

    @property
    def num_constraints(self):
        return self.numconstraints


class MyConstraintedProblem(tfco.ConstrainedMinimizationProblem):
    def __init__(self, weights, predictions, labels):
        self.weights=weights
        self.predictions=predictions
        self.labels=labels

    def objective(self):
        predictions = self.predictions
        if callable(predictions):
            predictions = predictions()
        return tf.compat.v1.losses.hinge_loss(labels=self.labels,
                                              logits=predictions)

    def constraints(self):
        w=self.weights
        if callable(w):
            w=self.weights()
        c=w-1.0
        c=tf.stack([c, 0.0-w])
        return c

    def proxy_constraints(self):
        pass

    @property
    def num_constraints(self):
        return 2*self.weights().shape[0]
