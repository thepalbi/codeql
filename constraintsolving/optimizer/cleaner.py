from orchestration.steps import OrchestrationStep, Context, CONSTRAINTS_DIR_KEY, MODELS_DIR_KEY, RESULTS_DIR_KEY, LOGS_DIR_KEY,     CONSTRAINTS_DIR_KEY, MODELS_DIR_KEY, RESULTS_DIR_KEY, LOGS_DIR_KEY, SOURCE_ENTITIES, SANITIZER_ENTITIES, SINK_ENTITIES,SRC_SAN_TUPLES_ENTITIES,SAN_SNK_TUPLES_ENTITIES, REPR_MAP_ENTITIES



class ModelCleanerStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        if SOURCE_ENTITIES not in ctx:
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