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

def test_generate_model_regression_with_sql_worse_and_bidding_system():
    generate_model_and_assert_regression_passes(
        'output/abhinavkumarl-bidding-system',
        'abhinavkumarl-bidding-system',
        'Sql',
        'SqlInjectionWorse',
        'test-sql-worse-bidding-system-expected-model'
    )


def generate_model_and_assert_regression_passes(project_dir: str, project_name: str, query_type: str, query_name: str, expected_files_dir: str):
    # Generate actual and expected results paths
    expected_entities_dir = os.path.join(
        global_config.sources_root, 'constraintsolving', 'tests', expected_files_dir)
    # Actual constraints directory will be the first found
    actual_entities_dir = os.path.join(
        global_config.sources_root, 'constraintsolving', 'constraints', project_name)
    # Select the first dir on constraints, assuming there's only one
    constraints_dir_name = os.listdir(actual_entities_dir)[0]
    actual_entities_dir = os.path.join(
        actual_entities_dir, constraints_dir_name)

    # Start orchestrator
    orch = Orchestrator(project_dir, project_name, query_type, query_name)

    # Run generate_entities and generate_model step
    orch.run_step('generate_entities')
    orch.run_step('generate_model')

    # Do results compare
    dir_comparer = filecmp.dircmp(expected_entities_dir, actual_entities_dir)

    # Assertions
    assert len(
        dir_comparer.diff_files) == 0, f"The following files differ: [{', '.join(dir_comparer.diff_files)}]"
    expected_file_count = len(os.listdir(expected_entities_dir))
    assert len(
        dir_comparer.same_files) == expected_file_count, f"Expected {expected_file_count} files to be equal, but found just {len(dir_comparer.same_files)}"
    assert len(
        dir_comparer.funny_files) == 0, f"There was a problem comparing the following files: [{', '.join(dir_comparer.funny_files)}]"
