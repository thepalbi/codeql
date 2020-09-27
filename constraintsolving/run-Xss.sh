#!/bin/sh
python3 main.py --project-dir /persistent/experiments/xss --query-name DomBasedXssWorse --query-type Xss --project-list xss_projects.txt --working-dir /mnt/wrk/xss --results-dir /persistent/experiments/results/xss $* run 
