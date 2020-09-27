#!/bin/sh
python3 main.py --project-dir /persistent/experiments/sql --query-name SqlInjectionWorse --query-type Sql --project-list sqlinjection_projects.txt  --working-dir /mnt/wrk/sql/ --results-dir /persistent/experiments/results/sql $* run
