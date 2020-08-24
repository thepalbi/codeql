from .wrapper import CodeQLWrapper
import os
import logging

ql_sources_root = os.environ["CODEQL_SOURCE_ROOT"]
constaintssolving_dir = os.path.join(ql_sources_root, "constraintsolving/")
logs_folder = os.path.join(constaintssolving_dir, "logs/")

SOURCES = "Sources"
SINKS = "Sinks"
SANITIZERS = "Sanitizers"


class DataGenerator:
    def __init__(self, project_dir: str, project_name: str):
        self.project_dir = project_dir
        self.project_name = project_name
        self.codeql = CodeQLWrapper()
        self.logger = logging.getLogger(self.__class__.__name__)
        self.generated_data_dir = self._get_generated_data_dir()

    def _get_generated_data_dir(self):
        generated_data_dir = os.path.join(constaintssolving_dir, f"data/{self.project_name}/")
        if not os.path.isdir(generated_data_dir):
            self.logger.warn("Creating directory for generated data at %s", generated_data_dir)
            os.makedirs(generated_data_dir)
        return generated_data_dir
        

    def _get_query_file(self, queried_entity: str, query_type: str) -> str:
        # ql_file = "/Users/thepalbi/Facultad/tesis/ql-atm/javascript/ql/src/Sources-{0}.ql".format(query)
        return os.path.join(ql_sources_root, f"javascript/ql/src/{queried_entity}-{query_type}.ql")

    def _get_bqrs_file(self, queried_entity: str, query_type: str) -> str:
        # bqrs_file = "output/1046224544_fontend_19c10c3/results/codeql-javascript/Sources-{0}.bqrs".format(query)
        return os.path.join(constaintssolving_dir, self.project_dir, f"results/codeql-javascript/{queried_entity}-{query_type}.bqrs")

    def generate(self, query_type: str):
        """Main data generation method, that orchestrates the process.

        Args:
            query_type (str): query type to generate data for (eg. Xss, Sql, NoSql, etc.).
        """        
        # sources
        sources_output_file = os.path.join(self.generated_data_dir, f"{self.project_name}-sinks-{query_type}.prop.csv")
        self.logger.info("Generating Sources data in file=[%s]", sources_output_file)
        self.codeql.database_analyze(self.project_dir, self._get_query_file(SOURCES, query_type), f"{logs_folder}/js-results.csv")
        self.codeql.bqrs_decode(
            self._get_bqrs_file(SOURCES, query_type),
            f"source{query_type}Classes",
            sources_output_file)
        # sinks
        # sanitizers
        # propagation graph
        # repr