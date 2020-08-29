import argparse
import logging
import os

from orchestration.orchestrator import Orchestrator

all_steps = "ALL"
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

parsed_arguments = parser.parse_args()
project_dir = os.path.normpath(parsed_arguments.project_dir)
project_name = os.path.basename(project_dir)
orchestrator = Orchestrator(project_dir, project_name, parsed_arguments.query_type,
                            parsed_arguments.query_name)

if __name__ == '__main__':
    if parsed_arguments.single_step == all_steps:
        orchestrator.run()
    else:
        orchestrator.run_step(parsed_arguments.single_step)
