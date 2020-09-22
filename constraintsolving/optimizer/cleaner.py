from orchestration.steps import OrchestrationStep, Context

class ModelCleanerStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        (ctx[SOURCE_ENTITIES],
         ctx[SINK_ENTITIES],
         ctx[SANITIZER_ENTITIES],
         ctx[SRC_SAN_TUPLES_ENTITIES],
         ctx[SAN_SNK_TUPLES_ENTITIES],
         ctx[REPR_MAP_ENTITIES]) = self.orchestrator.data_generator.get_entity_files(self.orchestrator.query_type)

        # TODO: Implement me
        return ctx

    def name(self) -> str:
        return "model_cleaner"