import filecmp
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
    # TODO: Change this to reuse test_name?
    expected_entities_dir = os.path.join(global_config.sources_root, 'constraintsolving', 'tests','test-sql-worse-bidding-system-expected-entities')
    actual_entities_dir = os.path.join(global_config.sources_root, 'constraintsolving', 'data', test_project_name)
    orchestrator.run_step('generate_entities')
    dir_comparer = filecmp.dircmp(expected_entities_dir, actual_entities_dir)
    assert len(dir_comparer.same_files) == 12
    assert len(dir_comparer.diff_files) == 0
    assert len(dir_comparer.funny_files) == 0