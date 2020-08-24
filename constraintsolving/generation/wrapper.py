import os
import subprocess
import logging


"""CodeQLWrapper is a codeql wrapper in Python. It finds the codeql executable through
the $CODEQL environment variable."""
class CodeQLWrapper:
    def __init__(self):
        try:
            # TODO: Check that file exists, and it's codeql?
            self._code_ql_binary_path = os.environ["CODEQL"]
            self._logs_directory = "logs/"
            self._logger = logging.getLogger(self.__class__.__name__)
        except KeyError:
            raise Exception(
                "'codeql' binary not found. Try setting the $CODEQL environment variable.")

    """Runs codeql running a query against the given database, and then interprets the results."""
    def database_analyze(self,
                         project: str,
                         query_file: str,
                         output_file: str,
                         output_format="csv"):
        command_and_arguments = [
            self._code_ql_binary_path,
            "database", "analyze",
            project,
            query_file,
            f"--format={output_format}",
            f"--logdir={self._logs_directory}",
            f"--output={output_file}"
        ]
        self._logger.info(
            "Running 'database analyze' for project=[%s] and query_file=[%s]", project, query_file)
        self._run_process(command_and_arguments)

    """Runs codeql analyzing the raw results of a BQRS file, formatting them in a file."""
    def bqrs_decode(self,
                    bqrs_file: str,
                    result_set: str,
                    output_file: str,
                    output_format="csv"):
        command_and_arguments = [
            self._code_ql_binary_path,
            "bqrs", "decode",
            bqrs_file,
            "--entities=string,url",
            "--result-set", result_set,
            f"--format={output_format}",
            f"--output={output_file}"
        ]
        self._logger.info(
            "Running 'bqrs decode' for bqrs_file=[%s] and result_set=[%s]", bqrs_file, result_set)
        self._run_process(command_and_arguments)

    def _run_process(self, command_and_arguments):
        self._logger.debug("command issued: %s", " ".join(command_and_arguments))
        try:
            process = subprocess.run(
                command_and_arguments, capture_output=True, check=True, text=True)
        except subprocess.CalledProcessError as call_error:
            self._logger.error("Error when executing codeql:\n%s", call_error.stderr)
            raise Exception("error calling codeql", call_error)
        self._logger.debug("Output from codeql:\n%s", process.stdout)
