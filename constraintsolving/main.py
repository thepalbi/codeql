import argparse
import logging
import os
import glob


from orchestration.orchestrator import Orchestrator


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


parsed_arguments = parser.parse_args()
project_dir = os.path.normpath(parsed_arguments.project_dir)
project_name = os.path.basename(project_dir)
orchestrator = Orchestrator(project_dir, project_name, parsed_arguments.query_type,
                            parsed_arguments.query_name)
projectListFile = parsed_arguments.projectListFile

if parsed_arguments.projectListFile is not None:
    run_separate_on_multiple_projects = True

if __name__ == '__main__':
    if parsed_arguments.single_step == all_steps:
        if run_separate_on_multiple_projects:
            projectList = open(projectListFile).readlines()
            for project in projectList:
                logging.info(f"Processing: {project}")
                projectPrefix =  os.path.join(project_dir, project.replace('\r', '').replace('\n', '').replace("/","_"))
                logging.info(f"Prefix: {projectPrefix}")
                projectCandidate = glob.glob(projectPrefix+"_*", recursive=True)
                print(projectCandidate)
                if len(projectCandidate)>0:
                    logging.info(f"Filename: {projectCandidate}")
                    orchestrator = Orchestrator(projectCandidate[0], 
                                                os.path.basename(projectCandidate[0]), 
                                                parsed_arguments.query_type,
                                                parsed_arguments.query_name)
                    orchestrator.run()
        else:
            orchestrator.run()
    else:
        orchestrator.run_step(parsed_arguments.single_step)
