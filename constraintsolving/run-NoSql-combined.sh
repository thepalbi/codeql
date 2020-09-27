#!/bin/sh
python3 main.py --project-dir /persistent/experiments/nosql --query-name NosqlInjectionWorse --query-type NoSql --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/ --results-dir . --scores-file allscores_NosqlInjectionWorse_avg.txt --single-step generate_scores $* run
