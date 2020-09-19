from orchestration.steps import OrchestrationStep, Context

class ModelCleanerStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        # TODO: Implement me
        return ctx

    def name(self) -> str:
        return "model_cleaner"