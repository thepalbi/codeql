from solver.config import SolverConfig
from solver.get_constraints import ConstraintBuilder
from solver.solve_gb import solve_constraints, solve_constraints_combine_model
from compute_metrics import getallmetrics
import os
from io import StringIO
import sys
import datetime
import time
import argparse
from glob import glob

parser=argparse.ArgumentParser()
parser.add_argument('-g', dest='generate_constraints', action='store_true')
parser.add_argument('-s', dest='solve', action='store_true')
parser.add_argument('--mode', dest='mode', default='combined')
parser.add_argument('--projects-folder', dest='projects_folder', default='./data')

args=parser.parse_args()
config = SolverConfig()

if args.generate_constraints:
    if args.mode == 'combined':
        # TODO: fix path to look for projects
        print("Combined mode")
        query_name = os.environ["QUERY_NAME"]
        projects = glob(args.projects_folder+'/'+ query_name+'/*')
    else:
        print("Single project mode. Project:",args.mode)
        projects = glob(args.projects_folder+'/'+args.mode)


    print("projects:", projects) 

    projectdir = args.mode if config.query is None else args.mode + "/" + config.query
    tstamp = str(int(time.mktime(datetime.datetime.now().timetuple())))
    projectdir = projectdir + "-" + tstamp
    print("Project dir: %s" % projectdir)

    os.makedirs("constraints/{0}".format(projectdir), exist_ok=True)
    os.makedirs("models/{0}".format(projectdir), exist_ok=True)
    os.makedirs("logs/{0}".format(projectdir), exist_ok=True)
    os.makedirs("results/{0}".format(projectdir), exist_ok=True)

    projects=[os.path.basename(k) for k in projects]
    print("Collected {0} projects".format(len(projects)))
    print("Creating events and reps")
    constraint_builder = ConstraintBuilder(args.mode,
                                           'constraints/{2}/{0}-{1}'.format(config.query,
                                                                                 tstamp, args.mode),
                                           config.min_rep_events,
                                           config.dataset_type,
                                           config.constraint_format,
                                           config.lambda_const)
    for proj in projects:
        try:
            print(proj)
            constraint_builder.readEventsAndReps(proj)
            constraint_builder.readAllKnown(proj, config.query, config.use_all_sanitizers)
        except:
            pass
    #exit(1)
    # remove events with no min reps
    #constraint_builder.removeRareEvents()
    # initiate all variables
    constraint_builder.createVariables()

    print("Adding constraints")
    for proj in projects:
        print(">>>>>>>>>>>>>Executing project %s" % proj)
        try:
            constraint_builder.generate_flow_constraints(proj, config.constraints_constant_C, config.query)
            pass
        except:
            import traceback as tb
            tb.print_exc()

    constraint_builder.writeVarConstrants()
    constraint_builder.writeKnownConstraints()
    constraint_builder.writeObjective()


if args.solve:
    projectdir = args.mode if config.query is None else args.mode + "/" + config.query

    candidates=glob("constraints/{0}".format(projectdir+"*"))
    candidates.sort(key=os.path.getmtime)
    projectdir=candidates[-1].replace("constraints/", "")
    print("Choosing latest project directory: %s" % projectdir)

    # run solver
    solve_constraints_combine_model(projectdir, config)
    #solve_constraints(newdir, config)

    # compute metrics
    getallmetrics(projectdir, config)


# with open("logs/{0}/log{1}.txt".format(config.projectdir, int(datetime.datetime.now().timestamp())), "w") as w:
#     w.write(mystdout.read())

