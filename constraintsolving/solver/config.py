import os

from orchestration import global_config


class SolverConfig:
    def __init__(self, query_name, query_type,
                 output_path=os.path.join(global_config.sources_root, "javascript", "ql", "src", "TSM", "tsm_scores"),
                 working_dir = global_config.working_directory,
                 results_dir = global_config.results_directory):
        # TODO: produce ql file with scores directly here
        self.codeql_output_path = output_path
        self.working_dir = working_dir
        self.results_dir = results_dir
        # constraint config
        self.query_name = query_name
        self.query_type = query_type
        self.constraints_constant_C = 0.75
        self.use_all_sanitizers = False

        # solve config
        self.lambda_const = 0.1
        self.trials = 1
        self.known_samples_ratio = 1.0
        self.no_flow_constraints = False
        self.min_rep_events = 5
        # use the large dataset or the small one with atleast 5 reps
        self.dataset_type = "small"
        self.constraint_format = "gb"

        # metric config
        self.trainingsizes = [self.known_samples_ratio]

        # only events above this threshold score will be predicted as src/snk/sans
        self.thresholds = [0.9]
