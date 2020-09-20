import gurobipy as gp
from gurobipy import GRB
from .MyConstraintedProblem import GBTaintSpecConstraints
import shutil
from .config import SolverConfig
from orchestration.steps import CONSTRAINTS_DIR_KEY, MODELS_DIR_KEY
import os

def solve_constraints_combine_model(config: SolverConfig, ctx):
    constraintsdir = ctx[CONSTRAINTS_DIR_KEY]
    modelfile_path = os.path.join(ctx[MODELS_DIR_KEY], f"gurobi_model_{config.known_samples_ratio}_{1}.lp")
    # write minimization objective
    print("Writing minimization objective")
    with open(modelfile_path, "w") as modelfile:
        modelfile.write("Minimize\n")
        modelfile.write(open(os.path.join(constraintsdir, "objective.txt")).read())
        modelfile.write("\n")

    # write constraints
    print("Writing flow and known constraints")
    with open(modelfile_path, "a") as modelfile:
        modelfile.write("Subject To\n")

    i=0
    with open(modelfile_path, "a") as modelfile:
        for l in open(os.path.join(constraintsdir, "constraints_flow.txt")).readlines():
            #parts = l.split("<=")
            #modelfile.write("R{0}: {1} - {2} <= 0\n".format(i, parts[0], parts[1].replace("+", "-").rstrip()))
            modelfile.write("R{0}: {1}\n".format(i,l.strip()))
            i += 1
        modelfile.flush()
        print("Done flows")
        try:
            for ltriple in open(os.path.join(constraintsdir, "constraints_known_src.txt")).readlines():
                for l in ltriple.split(","):
                    modelfile.write("R{0}: {1}\n".format(i, l ))
                    i += 1
            modelfile.flush()
        except:
            print("No known sources")

        try:
            for ltriple in open(os.path.join(constraintsdir, "constraints_known_san.txt"), encoding='utf-8').readlines():
                for l in ltriple.split(","):
                    modelfile.write("R{0}: {1}\n".format(i, l))
                    i += 1
            modelfile.flush()

        except:
            print("No known sanitizers")

        try:
            for ltriple in open(os.path.join(constraintsdir, "constraints_known_snk.txt"), encoding='utf-8').readlines():
                for l in ltriple.split(","):
                    modelfile.write("R{0}: {1} \n".format(i, l))
                    i += 1
            modelfile.flush()

        except:
            print("No known sinks")

        modelfile.write("\n")

    # shutil.copyfileobj(open(constraintsdir + "/constraints_flow.txt"), open(modelfile_path, "a"))
    # shutil.copyfileobj(open(constraintsdir + "/constraints_known_src.txt"), open(modelfile_path, "a"))
    # shutil.copyfileobj(open(constraintsdir + "/constraints_known_san.txt"), open(modelfile_path, "a"))
    # shutil.copyfileobj(open(constraintsdir + "/constraints_known_snk.txt"), open(modelfile_path, "a"))

    print("Writing Bounds")
    with open(modelfile_path, "a") as modelfile:
        modelfile.write("Bounds\n")
        for line in open(os.path.join(constraintsdir, "constraints_var.txt"), encoding='utf-8').readlines():
            if not line.startswith("0 "):
                modelfile.write("{0}\n".format(line.strip()))
    #shutil.copyfileobj(open(constraintsdir + "/constraints_var.txt"), open(modelfile_path, "a"))

    with open(modelfile_path, "a") as modelfile:
        modelfile.write("End")
    print("Done")

    print("reading model into gurobi")
    try:
        m = gp.read(modelfile_path)
        m.optimize()
        zero = 0
        non_zero = 0
        ones = 0
        eps_non_zero = 0
        
        with open(os.path.join(ctx[MODELS_DIR_KEY], f"results_gb_{config.known_samples_ratio}_{config.lambda_const}_{1}.txt"), "w") as resultfile:
            for v in m.getVars():
                if v.x == 0:
                    zero += 1
                elif v.x == 1:
                    ones += 1
                    if v.varName.startswith('e'):
                        eps_non_zero+=1
                else:
                    non_zero += 1
                    if v.varName.startswith('e'):
                        eps_non_zero+=1
            resultfile.write("\n".join(['{0}:{1}'.format(v.varName, v.x) for v in m.getVars()]))
        print('Obj: %g' % m.objVal)
        print('Zero: %g, Non-Zero: %g, Ones: %g, Eps: %g' % (zero, non_zero, ones, eps_non_zero))

    except gp.GurobiError as e:
        print('Error code ' + str(e.errno) + ': ' + str(e))

    except AttributeError:
        print('Encountered an attribute error')


def solve_constraints(projectdir, config:SolverConfig):
    constraintsdir = '{1}/constraints/{0}'.format(projectdir, config.working_dir)
    for trial in range(1, config.trials+1):
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

            problem=GBTaintSpecConstraints(vars, m, constraintsdir, config)

            # create constraints
            problem.add_constraints()

            # Set objective
            m.setObjective(problem.objective(), GRB.MINIMIZE)

            #if query is None:
            m.write("{1}/models/{0}/gurobi_model_{2}_{3}.lp".format(projectdir, config.working_dir,  config.known_samples_ratio, trial))
            m.write("{1}/models/{0}/gurobi_model_{@}_{3}.mps".format(projectdir, config.working_dir, config.known_samples_ratio, trial))
            # else:
            #     os.makedirs("models/{0}/{1}".format(projectdir, query), exist_ok=True)
            #     m.write("models/{0}/{1}/gurobi_model_{1}_{2}.lp".format(projectdir, query, known_samples_ratio, trial))
            #     m.write("models/{0}/{1}/gurobi_model_{1}_{2}.mps".format(projectdir, query, known_samples_ratio, trial))

            # Optimize model
            m.optimize()
            zero=0
            non_zero=0
            ones=0
            with open("{1}/models/{0}/results_gb_{2}_{3}_{4}.txt".format(projectdir,
                                                                    config.working_dir,
                                                                    config.known_samples_ratio, config.lambda_const, trial), "w") as resultfile:
                for v in m.getVars():
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


if __name__ == '__main__':
    #projectdir = 'eclipse_orion'
    #known_samples_ratio = 1
    #lambda_const = 0.1
    #solve_constraints(projectdir, 1, lambda_const, known_samples_ratio, "DomBasedXss")
    pass