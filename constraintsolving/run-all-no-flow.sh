#!/bin/sh

# clean Metrics brqs 
echo Cleaning all metrics brrs
sh ./cleanMetrics.sh

# invoke all steps Sql, NoSql, Xss for individual projects
echo Calling Optimize --no-flow on Sql projects
sh ./run-Sql.sh --single-step optimize --no-flow 
echo Calling generate_scores on Sql projects
sh ./run-Sql.sh --single-step generate_scores --no-flow

echo Calling Optimize --no-flow on NoSql projects
sh ./run-NoSql.sh --single-step optimize --no-flow  
echo Calling generate_scores on NoSql projects
sh ./run-NoSql.sh --single-step generate_scores --no-flow

echo Calling Optimize --no-flow on Xss projects
sh ./run-Xss.sh --single-step optimize --no-flow
echo Calling generate_scores on Xss projects
sh ./run-Xss.sh --single-step generate_scores --no-flow

# now compute the stats 
echo Computing stats for Sql
python3 generateMetrics.py --project-list sqlinjection_projects.txt --working-dir /mnt/wrk/sql/  > sql-stats-ind-no-flow.txt 
echo Computing stats for NoSql
python3 generateMetrics.py --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/  > nosql-stats-ind-no-flow.txt 
echo Computing stats for Xss
python3 generateMetrics.py --project-list xss_projects.txt --working-dir /mnt/wrk/xss/  > xss-stats-ind-no-flow.txt 

## same procedure with combined scores
# compute combined scores
echo Computing compibed scores for Sql
python3 misc/combinescores.py --project-dir /persistent/experiments/results/sql/ --query-name SqlInjectionWorse
echo Computing compibed scores for NoSql
python3 misc/combinescores.py --project-dir /persistent/experiments/results/nosql/ --query-name NosqlInjectionWorse
echo Computing compibed scores for Xss
python3 misc/combinescores.py --project-dir /persistent/experiments/results/xss/ --query-name DomBasedXssWorse

# clean Metrics brqs 
echo Cleaning all metrics brrs
sh ./cleanMetrics.sh

# now recompute using combined stats 
echo Calling generate_scores on Sql projects with combined scores
./run-Sql-combined.sh --no-flow
echo Calling generate_scores on NoSql projects with combined scores
./run-NoSql-combined.sh  --no-flow
echo Calling generate_scores on NoSql projects with combined scores
./run-Xss-combined.sh --no-flow

# now compute generate combined  stats 
echo Computing stats for Sql combined scores no-flow
python3 generateMetrics.py --project-list sqlinjection_projects.txt --working-dir /mnt/wrk/sql/ --combined > sql-stats-combined-no-flow.txt 
echo Computing stats for NoSql combined scores no-flow
python3 generateMetrics.py --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/ --combined > nosql-stats-combined-no-flow.txt 
echo Computing stats for Xss combined scores no-flow
python3 generateMetrics.py --project-list xss_projects.txt --working-dir /mnt/wrk/xss/ --combined > xss-stats-combined-no-flow.txt 
