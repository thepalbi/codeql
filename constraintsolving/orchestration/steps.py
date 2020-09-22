import logging
from typing import Dict, Any, NewType

Context = NewType('Context', Dict[str, Any])


# Inter-step context keys

# Generated entities keys
SOURCE_ENTITIES = "entities.sources"
SINK_ENTITIES = "entities.sinks"
SANITIZER_ENTITIES = "entities.sanitizers"
SRC_SAN_TUPLES_ENTITIES = "entities.src_san_tuple"
SAN_SNK_TUPLES_ENTITIES = "entities.san_snk_tuple"
REPR_MAP_ENTITIES = "entities.repr_map"

# Directory keys
CONSTRAINTS_DIR_KEY = "wd_constraints_dir"
MODELS_DIR_KEY = "wd_models_dir"
LOGS_DIR_KEY = "wd_logs_dir"
RESULTS_DIR_KEY = "results_dir"
WORKING_DIR_KEY = "working_dir"


# The OrchestrationStep class was moved to another file because of circular imports problems

class OrchestrationStep:
    def __init__(self, orchestrator):
        # TODO: Figure a way to add typing here, or at least not use the orchestrator as context passing mechanism
        self.orchestrator = orchestrator
        self.logger = logging.getLogger(self.__class__.__name__)

    def run(self, ctx: Context) -> Context:
        raise NotImplementedError()

    def name(self) -> str:
        raise NotImplementedError()