import logging
import os
from typing import Tuple

from orchestration.steps import OrchestrationStep, Context
from orchestration.steps import SOURCE_ENTITIES, SINK_ENTITIES, SANITIZER_ENTITIES, \
    SRC_SAN_TUPLES_ENTITIES, SAN_SNK_TUPLES_ENTITIES, REPR_MAP_ENTITIES
from orchestration import global_config
from .wrapper import CodeQLWrapper

constaintssolving_dir = os.path.join(
    global_config.sources_root, "constraintsolving/")
logs_folder = os.path.join(constaintssolving_dir, "logs/")

SOURCES = "Sources"
SINKS = "Sinks"
SANITIZERS = "Sanitizers"

SUPPORTED_QUERY_TYPES = ["NoSql", "Sql", "Xss"]


class GenerateEntitiesStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        # TODO: How to format this appropriately?
        (ctx[SOURCE_ENTITIES],
         ctx[SINK_ENTITIES],
         ctx[SANITIZER_ENTITIES],
         ctx[SRC_SAN_TUPLES_ENTITIES],
         ctx[SAN_SNK_TUPLES_ENTITIES],
         ctx[REPR_MAP_ENTITIES]) = self.orchestrator.data_generator.generate_entities(self.orchestrator.query_type)
        
        return ctx

    def name(self) -> str:
        return "generate_entities"


class GenerateScoresStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        self.orchestrator.data_generator.generate_scores(
            self.orchestrator.query_type)
        return ctx

    def name(self) -> str:
        return "generate_scores"


class DataGenerator:
    """DataGenerator extracts the events and propagation graph information from the
    provided project. It orchestrates the calls to the CodeQL toolchain, running 
    a couple of queries (for sources, sinks, sanitizers, and the PG).
    """

    steps = ["entities", "scores"]

    def __init__(self, project_dir: str, project_name: str,
                 working_dir: str = global_config.working_directory):
        """Creates a new DataGenerator for the given project

        Args:
            project_dir (str): the relative directory to projects CodeQL database
            project_name (str): the project slug (usually the folder name of the project's database)
        """
        self.project_dir = project_dir
        self.project_name = project_name
        self.codeql = CodeQLWrapper()
        # noinspection PyInterpreter
        self.logger = logging.getLogger(self.__class__.__name__)
        self.working_dir = working_dir
        self.generated_data_dir = self._get_generated_data_dir()

    def _get_generated_data_dir(self):
        generated_data_dir = os.path.join(
            constaintssolving_dir, f"{self.working_dir}/data/{self.project_name}/")
        if not os.path.isdir(generated_data_dir):
            self.logger.warn(
                "Creating directory for generated data at %s", generated_data_dir)
            os.makedirs(generated_data_dir)
        return generated_data_dir

    def _get_tsm_query_file_for_entity(self, queried_entity: str, query_type: str) -> str:
        return self._get_tsm_query_file(f"{queried_entity}-{query_type}.ql")

    def _get_tsm_query_file(self, filename: str) -> str:
        return os.path.join(global_config.sources_root, "javascript", "ql", "src", "TSM",  filename)

    def _get_tsm_bqrs_file_for_entity(self, queried_entity: str, query_type: str) -> str:
        return self._get_tsm_bqrs_file(f"{queried_entity}-{query_type}.bqrs")

    def _get_tsm_bqrs_file(self, filename: str) -> str:
        return os.path.join(constaintssolving_dir, self.project_dir, "results", "codeql-javascript", "TSM", filename)

    def generate_scores(self, query_type: str) -> Tuple[str, ...]:
        # Run metrics-snk query
        kind = "snk"
        metrics_file = "metrics_{0}_{1}".format(kind, query_type)
        self.logger.info("Generating events scores")
        self.codeql.database_analyze(
            self.project_dir,
            self._get_tsm_query_file(metrics_file + ".ql"),
            f"{logs_folder}/js-results.csv")

        # Get results BQRS file
        bqrs_metrics_file = self._get_tsm_bqrs_file(metrics_file + '.bqrs')
        capitalized_query_type = query_type.capitalize()
        tsm_worse_scores_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-tsmworse-ind-avg.prop.csv")
        tsm_worse_filtered_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-tsmworse-filtered-avg.prop.csv")

        # Extract result scores
        self.codeql.bqrs_decode(
            bqrs_metrics_file, f"getTSMWorseScores{query_type}", tsm_worse_scores_file)
        self.codeql.bqrs_decode(bqrs_metrics_file, f"getTSMWorseFiltered{query_type}",
                                tsm_worse_filtered_file)

        return tsm_worse_scores_file, tsm_worse_filtered_file

    def generate_entities(self, query_type: str) -> Tuple[str, ...]:
        """Main data generation method, that orchestrates the process.

        Args:
            query_type (str): query type to generate data for (eg. Xss, Sql, NoSql, etc.).
        """
        if not query_type in SUPPORTED_QUERY_TYPES:
            raise Exception(
                "{0} is not a supported query type. Currently supports {1}".format(query_type, SUPPORTED_QUERY_TYPES))
        sources_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-sources-{query_type}.prop.csv")
        sinks_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-sinks-{query_type}.prop.csv")
        sanitizers_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-sanitizers-{query_type}.prop.csv")
        # sources
        self._generate_for_entity(
            query_type, SOURCES, f"source{query_type}Classes", sources_output_file)
        # sinks
        self._generate_for_entity(
            query_type, SINKS, f"sink{query_type}Classes", sinks_output_file)
        # sanitizers
        self._generate_for_entity(
            query_type, SANITIZERS, f"sanitizer{query_type}Classes", sanitizers_output_file)

        # running propagation graph queries
        try:
            self.codeql.database_analyze(
                self.project_dir,
                self._get_tsm_query_file("PropagationGraph.ql"),
                f"{logs_folder}/js-results.csv")
        except Exception as error:
            self.logger.info("Error Analyzing PropagationGraph.ql")

        self.logger.info("Generating propagation graph data")

        # data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-src-san.prop.csv
        src_san_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-src-san-small.prop.csv")
        self.codeql.bqrs_decode(
            self._get_tsm_bqrs_file("PropagationGraph.bqrs"),
            "pairSrcSan",
            src_san_output_file)

        # data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-san-snk.prop.csv
        san_snk_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-san-snk-small.prop.csv")
        self.codeql.bqrs_decode(
            self._get_tsm_bqrs_file("PropagationGraph.bqrs"),
            "pairSanSnk",
            san_snk_output_file)

        # repr
        # data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-eventToConcatRep-small.prop.csv
        repr_mapping_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-eventToConcatRep-small.prop.csv")

        self.codeql.bqrs_decode(
            self._get_tsm_bqrs_file("PropagationGraph.bqrs"),
            "eventToConcatRep",
            repr_mapping_output_file)
        return (
            sources_output_file,
            sinks_output_file,
            sanitizers_output_file,
            src_san_output_file,
            san_snk_output_file,
            repr_mapping_output_file
        )

    def _generate_for_entity(self, query_type: str, entity_type: str, result_set: str, output_file: str):
        self.logger.info(
            "Generating %s data in file=[%s]", entity_type, output_file)
        self.codeql.database_analyze(
            self.project_dir,
            self._get_tsm_query_file_for_entity(
                entity_type,
                query_type),
            f"{logs_folder}/js-results.csv")
        self.codeql.bqrs_decode(
            self._get_tsm_bqrs_file_for_entity(entity_type, query_type),
            result_set,
            output_file)
