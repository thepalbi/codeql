import pytest
import os
from orchestration import global_config
from orchestration.orchestrator import Orchestrator
from orchestration.steps import OrchestrationStep
from typing import List


@pytest.fixture
def test_project() -> str:
    return 'output/abhinavkumarl-bidding-system'


@pytest.fixture
def test_project_name() -> str:
    return 'abhinavkumarl-bidding-system'


@pytest.fixture
def orchestrator(test_project, test_project_name):
    orch = Orchestrator(test_project, test_project_name, 'Sql', 'SqlInjectionWorse')
    return orch


def test_sql_worse_bidding_sytem(orchestrator, test_project_name):
    expected_entities_dir = os.path.join(global_config.sources_root, test_project_name)
    orchestrator.run_step('generate_entities')
    for _, _, files in os.walk(expected_entities_dir):
        assert len(files) > 0


