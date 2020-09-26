import argparse
import logging
import os
import glob


from orchestration.orchestrator import Orchestrator
from orchestration import global_config

def create_project_list(projectListFile):
    projectList = open(projectListFile).readlines()
    resultingProjects = [] 
    for project in projectList:
        if(project.startswith("#")):
            continue
        logging.info(f"Project name: {project}")
        projectPrefix =  os.path.join(project_dir, project.replace('\r', '').replace('\n', '').replace("/","_"))
        logging.info(f"Prefix: {projectPrefix}")
        projectCandidate = glob.glob(projectPrefix+"_*", recursive=True)
        print(projectCandidate)
        if len(projectCandidate)>0:
            resultingProjects.append(projectCandidate[0])
    return resultingProjects

all_steps = "ALL"

run_separate_on_multiple_projects = False

parser = argparse.ArgumentParser()
logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")

parser.add_argument("--single-step", dest="single_step", type=str, default=all_steps, metavar="STEP",
                    help="Runs a single step of the orchestrator named STEP")

parser.add_argument("--project-dir", dest="project_dir", required=True, type=str,
                    help="Directory of the CodeQL database")
parser.add_argument("--query-type", dest="query_type", required=True, type=str, choices=["Xss", "NoSql", "Sql"],
                    help="Type of the query to solve")
parser.add_argument("--query-name", dest="query_name", required=True, type=str,
                    choices=["NosqlInjectionWorse", "SqlInjectionWorse", "DomBasedXssWorse"],
                    help="Name of the query to solve")
parser.add_argument("--project-list", dest="projectListFile", required=False, type=str, 
                    help="Run all steps on the project passed on this list")

parser.add_argument("--results-dir", dest="results_dir", required=False, type=str,
                    help="Directory where results of the analysis are placed (replaces default in config.json")

parser.add_argument("--working-dir", dest="working_dir", required=False, type=str,
                    help="Working directory (replaces default in config.json")

parser.add_argument("--scores-file", dest="scores_file", required=False, type=str,
                    help="Name of file with the scores for repr (replaces reprScores.txt")

parser.add_argument("--no-flow", dest="no_flow", action='store_true', help='Ignore flow constraints')


parsed_arguments = parser.parse_args()
project_dir = os.path.normpath(parsed_arguments.project_dir)
results_dir = global_config.results_directory
working_dir = global_config.working_directory
scores_file = None
no_flow = False

if(parsed_arguments.results_dir is not None):
    results_dir = os.path.normpath(parsed_arguments.results_dir)

if(parsed_arguments.working_dir is not None):
    working_dir = os.path.normpath(parsed_arguments.working_dir)

if(parsed_arguments.scores_file is not None):
    scores_file = parsed_arguments.scores_file

if(parsed_arguments.no_flow):
    no_flow = True

logging.info(f"Results folder: {results_dir}")

projectListFile = parsed_arguments.projectListFile

if parsed_arguments.projectListFile is not None:
    run_separate_on_multiple_projects = True
    projectList = create_project_list(projectListFile)
else:
    projectList = [project_dir]


if __name__ == '__main__':
    for project in projectList:       
        print(project)
        project_name = os.path.basename(project)
        orchestrator = Orchestrator(project, project_name, parsed_arguments.query_type,
                            parsed_arguments.query_name, working_dir, results_dir,
                            scores_file, no_flow)
                            
        if parsed_arguments.single_step == all_steps:
            orchestrator.run()
        else:
            orchestrator.run_step(parsed_arguments.single_step)