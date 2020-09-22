import logging
from typing import List

from generation.data import DataGenerator, GenerateEntitiesStep, GenerateScoresStep
from optimizer.gurobi import GenerateModelStep, OptimizeStep

from orchestration import global_config
from orchestration.steps import Context


class UnknownStepException(Exception):
    def __init__(self, step_name: str, available_steps: List[str]):
        self.available_steps = available_steps
        self.step_name = step_name

    def __str__(self) -> str:
        return f"The orchestration step named '{self.step_name}' was not found. " \
               f"The available steps are: {self.available_steps}"


class Orchestrator:
    step_templates = [
        GenerateEntitiesStep,
        GenerateModelStep,
        OptimizeStep,
        GenerateScoresStep,
    ]
    # step_templates = [
    #     GenerateEntitiesStep
    # ]

    def __init__(self, project_dir: str, project_name: str, query_type: str, query_name: str, results_dir):
        self.query_type = query_type
        self.query_name = query_name
        self.project_dir = project_dir
        self.project_name = project_name
        self.results_dir = results_dir
        self.data_generator = DataGenerator(project_dir, project_name, global_config.working_directory, results_dir)
        self.logger = logging.getLogger(self.__class__.__name__)

        # Instantiate orchestration step templates
        self.steps = []
        for step_template in Orchestrator.step_templates:
            self.steps.append(step_template(self))

    def run(self):
        self.logger.info("Running ALL orchestration steps")
        ctx: Context = dict()
        for step in self.steps:
            ctx = self.do_run_step(step, ctx)

    def run_step(self, step_name: str):
        self.logger.info("Running SINGLE orchestration step")
        for step in self.steps:
            if step.name() == step_name:
                self.do_run_step(step, dict())
                return
        # Step was not found
        raise UnknownStepException(step_name, [step.name() for step in self.steps])

    def do_run_step(self, step, ctx: Context) -> Context:
        separator = ">" * 5
        self.logger.info("%s Running orchestration step: %s %s", separator, step.name(), separator)
        return step.run(ctx)
