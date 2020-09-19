import logging
from typing import Dict, Any, NewType

Context = NewType('Context', Dict[str, Any])

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