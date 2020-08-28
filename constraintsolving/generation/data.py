import logging
import os
from typing import Tuple

from .wrapper import CodeQLWrapper

ql_sources_root = os.environ["CODEQL_SOURCE_ROOT"]
constaintssolving_dir = os.path.join(ql_sources_root, "constraintsolving/")
logs_folder = os.path.join(constaintssolving_dir, "logs/")

SOURCES = "Sources"
SINKS = "Sinks"
SANITIZERS = "Sanitizers"

SUPPORTED_QUERY_TYPES = ["NoSql", "Sql", "Xss"]


class CodeQlOrchestrator:
    """DataGenerator extracts the events and propagation graph information from the
    provided project. It orchestrates the calls to the CodeQL toolchain, running 
    a couple of queries (for sources, sinks, sanitizers, and the PG).
    """

    steps = ["entities", "scores"]

    def __init__(self, project_dir: str, project_name: str):
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
        self.generated_data_dir = self._get_generated_data_dir()

    def _get_generated_data_dir(self):
        generated_data_dir = os.path.join(
            constaintssolving_dir, f"data/{self.project_name}/")
        if not os.path.isdir(generated_data_dir):
            self.logger.warn(
                "Creating directory for generated data at %s", generated_data_dir)
            os.makedirs(generated_data_dir)
        return generated_data_dir

    def _get_query_file_for_entity(self, queried_entity: str, query_type: str) -> str:
        return self._get_query_file(f"{queried_entity}-{query_type}.ql")

    def _get_query_file(self, filename: str) -> str:
        return os.path.join(ql_sources_root, "javascript/ql/src/", filename)

    def _get_bqrs_file_for_entity(self, queried_entity: str, query_type: str) -> str:
        return self._get_bqrs_file(f"{queried_entity}-{query_type}.bqrs")

    def _get_bqrs_file(self, filename: str) -> str:
        return os.path.join(constaintssolving_dir, self.project_dir, "results/codeql-javascript/", filename)

    def generate_scores(self, query_type: str) -> Tuple[str, ...]:
        # Run metrics-snk query
        kind = "snk"
        metrics_file = "metrics_{0}_{1}".format(kind, query_type)
        self.logger.info("Generating events scores")
        self.codeql.database_analyze(
            self.project_dir,
            self._get_query_file(metrics_file+'.ql'),
            f"{logs_folder}/js-results.csv")

        # Get results BQRS file
        bqrs_metrics_file = self._get_bqrs_file(metrics_file+'.bqrs')
        capitalized_query_type = query_type.capitalize()
        tsm_worse_scores_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-tsmworse-ind-avg.prop.csv")
        tsm_worse_filtered_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-tsmworse-filtered-avg.prop.csv")

        # Extract result scores
        self.codeql.bqrs_decode(bqrs_metrics_file, f"getTSMWorseScores{capitalized_query_type}", tsm_worse_scores_file)
        self.codeql.bqrs_decode(bqrs_metrics_file, f"getTSMWorseFiltered{capitalized_query_type}", tsm_worse_filtered_file)

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
        self.codeql.database_analyze(
            self.project_dir,
            self._get_query_file("PropagationGraph.ql"),
            f"{logs_folder}/js-results.csv")
        # extracting results from bqrs files
        # data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-triple-id-small.prop.csv
        tiplets_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-triple-id-small.prop.csv")
        # data/1046224544_fontend_19c10c3/1046224544_fontend_19c10c3-eventToConcatRep-small.prop.csv
        repr_mapping_output_file = os.path.join(
            self.generated_data_dir, f"{self.project_name}-eventToConcatRep-small.prop.csv")

        self.logger.info("Generating propagation graph data")
        # propagation graph triplets
        self.codeql.bqrs_decode(
            self._get_bqrs_file("PropagationGraph.bqrs"),
            "tripleWRepID",
            tiplets_output_file)
        # repr
        self.codeql.bqrs_decode(
            self._get_bqrs_file("PropagationGraph.bqrs"),
            "eventToConcatRep",
            repr_mapping_output_file)
        return (
            sources_output_file,
            sinks_output_file,
            sanitizers_output_file,
            tiplets_output_file,
            repr_mapping_output_file
        )

    def _generate_for_entity(self, query_type: str, entity_type: str, result_set: str, output_file: str):
        self.logger.info(
            "Generating %s data in file=[%s]", entity_type, output_file)
        self.codeql.database_analyze(
            self.project_dir,
            self._get_query_file_for_entity(
                entity_type,
                query_type),
            f"{logs_folder}/js-results.csv")
        self.codeql.bqrs_decode(
            self._get_bqrs_file_for_entity(entity_type, query_type),
            result_set,
            output_file)
