#!/bin/sh
python3 main.py --project-dir /persistent/experiments/nosql --query-name NosqlInjectionWorse --query-type NoSql --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/ --results-dir /persistent/experiments/results/nosql/ $* run
