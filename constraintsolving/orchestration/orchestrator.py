import logging
from typing import List

from generation.data import DataGenerator, GenerateEntitiesStep, GenerateScoresStep
from optimizer.gurobi import GenerateModelStep, OptimizeStep

from orchestration import global_config


class UnknownStepException(Exception):
    def __init__(self, step_name: str, available_steps: List[str]):
        self.available_steps = available_steps
        self.step_name = step_name

    def __str__(self) -> str:
        return f"The orchestration step named '{self.step_name}' was not found. " \
               f"The available steps are: {self.available_steps}"


# TODO: Move all environment variables (CODEQL, etc.) to a yaml config file that the orchestrator know about
class Orchestrator:
    step_templates = [
        GenerateEntitiesStep,
        GenerateModelStep,
        OptimizeStep,
        GenerateScoresStep,
    ]

    def __init__(self, project_dir: str, project_name: str, query_type: str, query_name: str):
        self.query_type = query_type
        self.query_name = query_name
        self.project_dir = project_dir
        self.project_name = project_name
        self.data_generator = DataGenerator(project_dir, project_name, global_config.working_directory)
        self.logger = logging.getLogger(self.__class__.__name__)

        # Instantiate orchestration step templates
        self.steps = []
        for step_template in Orchestrator.step_templates:
            self.steps.append(step_template(self))

    def run(self):
        self.logger.info("Running ALL orchestration steps")
        for step in self.steps:
            self.do_run_step(step)

    def run_step(self, step_name: str):
        self.logger.info("Running SINGLE orchestration step")
        for step in self.steps:
            if step.name() == step_name:
                self.do_run_step(step)
                return
        # Step was not found
        raise UnknownStepException(step_name, [step.name() for step in self.steps])

    def do_run_step(self, step):
        separator = ">" * 5
        self.logger.info("%s Running orchestration step: %s %s", separator, step.name(), separator)
        step.run()
