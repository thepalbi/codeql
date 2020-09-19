from orchestration.steps import OrchestrationStep, Context

class ModelCleanerStep(OrchestrationStep):
    def run(self, ctx: Context) -> Context:
        return ctx

    def name(self) -> str:
        return "model_cleaner"