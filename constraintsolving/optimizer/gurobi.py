import datetime
import os
import traceback
from glob import glob

import sys
import time

from compute_metrics import getallmetrics, createReprPredicate
from orchestration.steps import OrchestrationStep, Context,\
    CONSTRAINTS_DIR_KEY, MODELS_DIR_KEY, RESULTS_DIR_KEY, WORKING_DIR_KEY, LOGS_DIR_KEY, \
    SOURCE_ENTITIES, SANITIZER_ENTITIES,  SINK_ENTITIES,SRC_SAN_TUPLES_ENTITIES,SAN_SNK_TUPLES_ENTITIES, REPR_MAP_ENTITIES, \
    SINGLE_STEP_NAME

from solver.config import SolverConfig
from solver.get_constraints import ConstraintBuilder
from solver.solve_gb import solve_constraints_combine_model, solve_constraints


class GenerateModelStep(OrchestrationStep):
    def populate(self, ctx: Context) -> Context:
        if self.running_just_optimize_step(ctx):
            (ctx[CONSTRAINTS_DIR_KEY],
            ctx[MODELS_DIR_KEY],
            ctx[LOGS_DIR_KEY]) = self.get_existing_working_directories(self.orchestrator.query_name, ctx[WORKING_DIR_KEY])
        else:
            (ctx[CONSTRAINTS_DIR_KEY],
            ctx[MODELS_DIR_KEY],
            ctx[LOGS_DIR_KEY]) = self.get_new_working_directories(self.orchestrator.query_name, ctx[WORKING_DIR_KEY])
        return ctx

    def running_just_optimize_step(self, ctx):
        return (SINGLE_STEP_NAME in ctx) and ctx[SINGLE_STEP_NAME] == "optimize"

    def run(self, ctx: Context) -> Context:
        # TODO: Implement --mode=combined model generation
        # TODO: Extract this as an orchestrator config?
        # TODO: Fix logging
        results_dir = ctx[RESULTS_DIR_KEY]
        working_dir = ctx[WORKING_DIR_KEY]
        constraints_dir = ctx[CONSTRAINTS_DIR_KEY]
        models_dir = ctx[MODELS_DIR_KEY]
        logs_dir = ctx[LOGS_DIR_KEY]

        
        config = SolverConfig(query_name=self.orchestrator.query_name, query_type=self.orchestrator.query_type,
                                 working_dir=working_dir, results_dir=results_dir)

        projects_folder = os.path.join(config.working_dir, "data")
        projects = glob(os.path.join(projects_folder, self.orchestrator.project_name))
        # self.logger.info("Generating models for projects: %s", projects)

        # timestamp = str(int(time.mktime(datetime.datetime.now().timetuple())))
        # optimizer_run_name = f"{config.query_name}-{timestamp}"
        # project_name = self.orchestrator.project_name
        # self.logger.info(f"Project dir: {project_name}/{optimizer_run_name}")

        # constraints_dir = os.path.join(config.working_dir, "constraints", project_name, optimizer_run_name)
        # models_dir = os.path.join(config.working_dir, "models", project_name, optimizer_run_name)
        # logs_dir = os.path.join(config.working_dir, "logs", project_name, optimizer_run_name)
        #results_dir = os.path.join(config.results_dir, project_name, optimizer_run_name)
        #ctx[RESULTS_DIR_KEY] = results_dir

        # Create directories if needed
        for directory in [constraints_dir, models_dir, logs_dir, results_dir]:
            os.makedirs(directory, exist_ok=True)

        projects = [os.path.basename(k) for k in projects]
        self.logger.info("Collected {0} projects".format(len(projects)))
        self.logger.info("Creating events and reps")
        constraint_builder = ConstraintBuilder(self.orchestrator.project_name,
                                               constraints_dir,
                                               config.min_rep_events,
                                               config.dataset_type,
                                               config.constraint_format,
                                               config.lambda_const,
                                               config.working_dir)
        for project in projects:
            try:
                self.logger.info("Analizing project: %s", project)
                constraint_builder.readEventsAndReps(project, ctx)
                constraint_builder.readAllKnown(project, config.query_name, config.query_type,
                                                config.use_all_sanitizers, ctx)
            except Exception as e:
                self.logger.info("There was a problem reading events!")
                traceback.self.logger.info_exc(file=sys.stdout)
                pass
        # exit(1)
        # remove events with no min reps
        # constraint_builder.removeRareEvents()
        # initiate all variables
        constraint_builder.createVariables(ctx)

        self.logger.info("Adding constraints")
        for project in projects:
            self.logger.info(">>>>>>>>>>>>>Executing project %s" % project)
            try:
                # Write flow constraints, as in Seldon 4.2
                #constraint_builder.generate_flow_constraints(project, config.constraints_constant_C, config.query_name)
                constraint_builder.generate_flow_constraints_from_pairs(project, config.constraints_constant_C, query=config.query_name, ctx=ctx)
                pass
            except:
                import traceback as tb
                tb.print_exc()

        # Write variable constraints as in Seldon 4.1
        constraint_builder.writeVarConstrants(ctx)
        constraint_builder.writeKnownConstraints(ctx)
        # Write objective as in Seldon 4.4, minimizing the violation of each constraint
        constraint_builder.writeObjective(ctx)

        return ctx

    def name(self) -> str:
        return "generate_model"


class OptimizeStep(OrchestrationStep):
    def populate(self, ctx: Context) -> Context:
        return ctx

    def run(self, ctx: Context) -> Context:
        # TODO: Extract this and share between steps. Maybe add some context passing between steps
        # TODO: Share this in ctx
        results_dir = ctx[RESULTS_DIR_KEY]
        working_dir = ctx[WORKING_DIR_KEY]

        config = SolverConfig(query_name=self.orchestrator.query_name, query_type=self.orchestrator.query_type,
                                working_dir=working_dir, results_dir=results_dir)

        config.no_flow_constraints = self.orchestrator.no_flow
        # Run solver
        solve_constraints_combine_model(config, ctx)
        # this looks like a more engineered version but didn't work for me
        #solve_constraints(config, ctx)

        # Compute metrics
        getallmetrics(config, ctx)
        #createReprPredicate(ctx)

        return ctx

    def name(self) -> str:
        return "optimize"
