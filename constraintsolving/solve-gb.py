import gurobipy as gp
from gurobipy import GRB
from MyConstraintedProblem import GBTaintSpecConstraints
import re
projectdir='eclipse_orion'
constraintsdir='constraints/{0}'.format(projectdir)
known_samples_ratio=0.1
for trial in [1,2,3]:
    try:
        # Create a new model
        m = gp.Model("mip1")
        vars_to_train=[]
        vars=dict()
        totalvars=0
        with open("{0}/var.txt".format(constraintsdir)) as varsfile:
            for line in varsfile.readlines():
                parts = line.split(":")
                # if parts[1] == "constant":
                #     v = m.addVar(vtype=GRB.CONTINUOUS, lb=float(parts[2]), ub=float(parts[2]), name=parts[0])
                #     totalvars+=1
                #     vars[parts[0]] = v
                # else:
                if "eps" in parts[0]:
                    v = m.addVar(vtype=GRB.CONTINUOUS, lb=0.0, name=parts[0])
                    totalvars += 1
                    vars_to_train.append(v)
                    vars[parts[0]] = v
                else:
                    v = m.addVar(vtype=GRB.CONTINUOUS, lb=0.0, ub=1.0, name=parts[0])
                    totalvars += 1
                    vars_to_train.append(v)
                    vars[parts[0]] = v

        problem=GBTaintSpecConstraints(vars, m, constraintsdir, known_samples_ratio)

        # create constraints
        problem.constraints()

        # Set objective
        m.setObjective(problem.objective(), GRB.MINIMIZE)

        # Add constraint: x + 2 y + 3 z <= 4
        #m.addConstr(x + 2 * y + 3 * z <= 4, "c0")

        # Add constraint: x + y >= 1
        #m.addConstr(x + y >= 1, "c1")
        m.write("models/{0}/gurobi_model_{1}_{2}.lp".format(projectdir, known_samples_ratio, trial))
        m.write("models/{0}/gurobi_model_{1}_{2}.mps".format(projectdir, known_samples_ratio, trial))
        # Optimize model
        m.optimize()
        zero=0
        non_zero=0
        ones=0
        with open("models/{0}/results_gb_{1}_{2}.txt".format(projectdir, known_samples_ratio, trial), "w") as resultfile:
            for v in m.getVars():
                #print('%s %g' % (v.varName, v.x))
                resultfile.write('%s:%g\n' % (v.varName, v.x))
                if v.x == 0:
                    zero+=1
                elif v.x == 1:
                    ones+=1
                else:
                    non_zero+=1

        print('Obj: %g' % m.objVal)
        print('Zero: %g, Non-Zero: %g, Ones: %g' % (zero, non_zero, ones))

    except gp.GurobiError as e:
        print('Error code ' + str(e.errno) + ': ' + str(e))

    except AttributeError:
        print('Encountered an attribute error')