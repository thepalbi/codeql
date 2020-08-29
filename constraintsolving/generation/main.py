import argparse
import logging
import os

import sys

from generation import DataGenerator

logging.basicConfig(level=logging.INFO, format="[%(levelname)s\t%(asctime)s] %(name)s\t%(message)s")
parser = argparse.ArgumentParser()

parser.add_argument("--step",
                    dest="step",
                    choices=DataGenerator.steps,
                    type=str,
                    required=True,
                    help="The generator orchestration step to run")

parser.add_argument("--project-dir",
                    dest="project_dir",
                    type=str,
                    required=True,
                    help="The CodeQL database directory")

if __name__ == "__main__":
    arguments = parser.parse_args()
    project_name = os.path.basename(arguments.project_dir)
    query_type = os.environ["QUERY_TYPE"]
    generator = DataGenerator(arguments.project_dir, project_name)
    if arguments.step == "entities":
        generator.generate_entities(query_type)
    else:
        generator.generate_scores(query_type)
