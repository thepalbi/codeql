import filecmp
import logging
import pytest
import os
from orchestration import global_config
from orchestration.orchestrator import Orchestrator
from orchestration.steps import OrchestrationStep
from typing import List

logger = logging.getLogger('test-logger')


# TODO: Do some automattic test generations based of test_names?
# TODO: Add test cleanup

def test_generate_entities_regression_with_sql_worse_and_bidding_system():
    generate_entities_and_assert_regression_passes(
        'output/abhinavkumarl-bidding-system',
        'abhinavkumarl-bidding-system',
        'Sql',
        'SqlInjectionWorse',
        'test-sql-worse-bidding-system-expected-entities'
    )


def generate_entities_and_assert_regression_passes(project_dir: str, project_name: str, query_type: str, query_name: str, expected_files_dir: str):
    # Generate actual and expected results paths
    expected_entities_dir = os.path.join(
        global_config.sources_root, 'constraintsolving', 'tests', expected_files_dir)
    actual_entities_dir = os.path.join(
        global_config.sources_root, 'constraintsolving', 'data', project_name)
    orch = Orchestrator(project_dir, project_name, query_type, query_name)
    expected_file_count = len(os.listdir(expected_entities_dir))

    # Run generate_entities step
    orch.run_step('generate_entities')

    # Do results compare
    dir_comparer = filecmp.dircmp(expected_entities_dir, actual_entities_dir)

    # Assertions
    assert len(
        dir_comparer.diff_files) == 0, f"The following files differ: [{', '.join(dir_comparer.diff_files)}]"
    assert len(
        dir_comparer.same_files) == expected_file_count, f"Expected {expected_file_count} files to be equal, but found just {len(dir_comparer.same_files)}"
    assert len(
        dir_comparer.funny_files) == 0, f"There was a problem comparing the following files: [{', '.join(dir_comparer.funny_files)}]"
