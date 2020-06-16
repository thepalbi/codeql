from config import SolverConfig
from get_constraints import generate_constraints
from solve_gb import solve_constraints
from compute_metrics import getallmetrics

config = SolverConfig()
projectdir = config.projectdir
outputdir = config.constraints_output_dir
global_constant_C = config.constraints_constant_C

# generate constraints
#generate_constraints(projectdir, outputdir, global_constant_C)

# run solver
#solve_constraints(projectdir, config.trials, config.lambda_const, config.known_samples_ratio)

# compute metrics
getallmetrics(projectdir, config.dirprefix, config.trainingsizes, config.thresholds, config.lambda_const, config.trials)
