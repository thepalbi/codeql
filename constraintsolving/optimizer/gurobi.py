import datetime
import os
import traceback
from glob import glob

import sys
import time

from compute_metrics import getallmetrics, createReprPredicate
from orchestration.steps import OrchestrationStep
from solver.config import SolverConfig
from solver.get_constraints import ConstraintBuilder
from solver.solve_gb import solve_constraints_combine_model


class GenerateModelStep(OrchestrationStep):
    def run(self) -> None:
        # TODO: Implement --mode=combined model generation
        # TODO: Extract this as an orchestrator config?
        # TODO: Fix logging
        config = SolverConfig(query_name=self.orchestrator.query_name, query_type=self.orchestrator.query_type)
        projects_folder = os.path.join(config.working_dir, "data")
        projects = glob(os.path.join(projects_folder, self.orchestrator.project_name))
        self.logger.info("Generating models for projects: %s", projects)

        optimizer_run_name = self.orchestrator.project_name if config.query_name is None \
            else self.orchestrator.project_name + "/" + config.query_name
        timestamp = str(int(time.mktime(datetime.datetime.now().timetuple())))
        optimizer_run_name = optimizer_run_name + "-" + timestamp
        self.logger.info("Project dir: %s" % optimizer_run_name)

        os.makedirs("{1}/constraints/{0}".format(optimizer_run_name, config.working_dir), exist_ok=True)
        os.makedirs("{1}/models/{0}".format(optimizer_run_name, config.working_dir), exist_ok=True)
        os.makedirs("{1}/logs/{0}".format(optimizer_run_name, config.working_dir), exist_ok=True)
        os.makedirs("{1}/{0}".format(optimizer_run_name, config.results_dir), exist_ok=True)

        projects = [os.path.basename(k) for k in projects]
        self.logger.info("Collected {0} projects".format(len(projects)))
        self.logger.info("Creating events and reps")
        constraint_builder = ConstraintBuilder(self.orchestrator.project_name,
                                               '{3}/constraints/{2}/{0}-{1}'.format(config.query_name, timestamp,
                                                                                self.orchestrator.project_name,
                                                                                config.working_dir),
                                               config.min_rep_events,
                                               config.dataset_type,
                                               config.constraint_format,
                                               config.lambda_const,
                                               config.working_dir)
        for project in projects:
            try:
                self.logger.info("Analizing project: %s", project)
                constraint_builder.readEventsAndReps(project)
                constraint_builder.readAllKnown(project, config.query_name, config.query_type,
                                                config.use_all_sanitizers)
            except Exception as e:
                self.logger.info("There was a problem reading events!")
                traceback.self.logger.info_exc(file=sys.stdout)
                pass
        # exit(1)
        # remove events with no min reps
        # constraint_builder.removeRareEvents()
        # initiate all variables
        constraint_builder.createVariables()

        self.logger.info("Adding constraints")
        for project in projects:
            self.logger.info(">>>>>>>>>>>>>Executing project %s" % project)
            try:
                # Write flow constraints, as in Seldon 4.2
                #constraint_builder.generate_flow_constraints(project, config.constraints_constant_C, config.query_name)
                constraint_builder.generate_flow_constraints_from_pairs(project, config.constraints_constant_C, config.query_name)
                pass
            except:
                import traceback as tb
                tb.print_exc()

        # Write variable constraints as in Seldon 4.1
        constraint_builder.writeVarConstrants()
        constraint_builder.writeKnownConstraints()
        # Write objective as in Seldon 4.4, minimizing the violation of each constraint
        constraint_builder.writeObjective()

    def name(self) -> str:
        return "generate_model"


class OptimizeStep(OrchestrationStep):
    def run(self) -> None:
        # TODO: Extract this and share between steps. Maybe add some context passing between steps
        optimizer_run_name = self.orchestrator.project_name if self.orchestrator.query_name is None \
            else self.orchestrator.project_name + "/" + self.orchestrator.query_name
        # TODO: Also share this between steps
        config = SolverConfig(query_name=self.orchestrator.query_name, query_type=self.orchestrator.query_type)

        constraints_dir = "{0}/constraints/".format(config.working_dir)
        candidates = glob("{1}{0}".format(optimizer_run_name + "*",constraints_dir))
        candidates.sort(key=os.path.getmtime)
        optimizer_run_name = candidates[-1].replace(constraints_dir, "")
        print("Choosing latest project directory: %s" % optimizer_run_name)

        # run solver
        solve_constraints_combine_model(optimizer_run_name, config)
        # solve_constraints(newdir, config)

        # compute metrics
        getallmetrics(optimizer_run_name, config)
        createReprPredicate(optimizer_run_name, self.orchestrator.query_type, self.orchestrator.query_name)

    def name(self) -> str:
        return "optimize"
