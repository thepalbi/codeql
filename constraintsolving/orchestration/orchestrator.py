import logging
from typing import List

from generation.data import DataGenerator, GenerateEntitiesStep, GenerateScoresStep
from optimizer.gurobi import GenerateModelStep, OptimizeStep

from orchestration import global_config
from orchestration.steps import Context,  RESULTS_DIR_KEY, WORKING_DIR_KEY

import os 
import glob

class UnknownStepException(Exception):
    def __init__(self, step_name: str, available_steps: List[str]):
        self.available_steps = available_steps
        self.step_name = step_name

    def __str__(self) -> str:
        return f"The orchestration step named '{self.step_name}' was not found. " \
               f"The available steps are: {self.available_steps}"


class Orchestrator:
    # It's important to respect the steps order, since each of them populates the context for the incoming ones.
    step_templates = [
        GenerateEntitiesStep,
        GenerateModelStep,
        OptimizeStep,
        GenerateScoresStep,
    ]

    def __init__(self, project_dir: str, project_name: str, query_type: str, query_name: str, 
                 working_dir: str, results_dir: str, scores_file = None, no_flow: bool = False):
        self.query_type = query_type
        self.query_name = query_name
        self.project_dir = project_dir
        self.project_name = project_name
        self.working_dir = working_dir
        self.results_dir = results_dir
        self.no_flow = no_flow
        self.scores_file = scores_file
        if scores_file == None: 
            self.combinedScore = False
            self.scores_file = "reprScores.txt"
        else:
            self.scores_file = scores_file
            self.combinedScore = True
        self.data_generator = DataGenerator(project_dir, project_name, working_dir, results_dir)
        self.logger = logging.getLogger(self.__class__.__name__)
        # Instantiate orchestration step templates
        self.steps = []
        for step_template in Orchestrator.step_templates:
            self.steps.append(step_template(self))

    def compute_results_dir(self):
        if(not self.combinedScore):
            project_name = self.project_name
            #print(self.query_name)
            #print(self.results_dir)
            #timestamp = str(int(time.mktime(datetime.datetime.now().timetuple())))
            patternToSearch = os.path.join(self.results_dir, project_name)+ "/{0}-*".format(self.query_name)
            #print(patternToSearch)
            results_candidates = glob.glob(patternToSearch)
            print(results_candidates)
            if len(results_candidates)>0:
                results_candidates.sort()
                result_dir = results_candidates[-1]
                print(result_dir)
            else:
                raise ValueError('Cannot find results directory for ' + self.project_name )
            return result_dir
        else:
            return self.results_dir

    def run(self):
        self.logger.info("Running ALL orchestration steps")
        ctx = self.starting_ctx()
        
        for step in self.steps:
            ctx = step.populate(ctx)
            ctx = self.do_run_step(step, ctx)

    def run_step(self, step_name: str):
        self.logger.info("Running SINGLE orchestration step")
        ctx = self.starting_ctx()
        for step in self.steps:
            if step.name() == step_name:
                ctx = step.populate(ctx)
                self.do_run_step(step, ctx)
                return
            else:
                # Make each previous step populate the ctx
                ctx = step.populate(ctx)

        # Step was not found
        raise UnknownStepException(step_name, [step.name() for step in self.steps])

    def do_run_step(self, step, ctx: Context) -> Context:
        separator = ">" * 5
        self.logger.info("%s Running orchestration step: %s %s", separator, step.name(), separator)
        return step.run(ctx)

    def starting_ctx(self) -> Context:
        ctx = dict()
        ctx[RESULTS_DIR_KEY] = self.compute_results_dir()
        ctx[WORKING_DIR_KEY] = self.working_dir
        return ctx
 