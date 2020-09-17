import json

CODEQL_SOURCES_ROOT_KEY = "codeQLSourcesRoot"
CODEQL_EXECUTABLE_KEY = "codeQLExecutable"


class Configuration:
    def __init__(self, config_file_path="config.json"):
        with open(config_file_path, "r") as config_file:
            self.config = json.load(config_file)

    @property
    def codeql_executable(self):
        return self.config[CODEQL_EXECUTABLE_KEY]

    @property
    def sources_root(self):
        return self.config[CODEQL_SOURCES_ROOT_KEY]

    def __getattr__(self, item):
        return self.config[item]
