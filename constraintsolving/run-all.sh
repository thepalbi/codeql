#!/bin/sh

# clean Metrics brqs 
sh ./cleanMetrics.sh

# invoke all steps Sql, NoSql, Xss for individual projects
echo Calling Optimize  on Sql projects
sh ./run-Sql.sh --single-step optimize $* 
echo Calling generate_scores on Sql projects
sh ./run-Sql.sh --single-step generate_scores --kind snk $* 
sh ./run-Sql.sh --single-step generate_scores --kind src $* 
sh ./run-Sql.sh --single-step generate_scores --kind san $* 

echo Calling Optimize on NoSql projects 
sh ./run-NoSql.sh --single-step optimize $* 
echo Calling generate_scores on NoSql projects
sh ./run-NoSql.sh --single-step generate_scores --kind snk $* 
sh ./run-NoSql.sh --single-step generate_scores --kind src $* 
sh ./run-NoSql.sh --single-step generate_scores --kind san $* 

echo Calling Optimize --no-flow on Xss projects
sh ./run-Xss.sh --single-step optimize $*
echo Calling generate_scores on Xss projects
sh ./run-Xss.sh --single-step generate_scores --kind snk $* 
sh ./run-Xss.sh --single-step generate_scores --kind src $* 
sh ./run-Xss.sh --single-step generate_scores --kind san $* 


# now compute the stats 
python3 generateMetrics.py --project-list sqlinjection_projects.txt --working-dir /mnt/wrk/sql/  > sql-stats-ind.txt 
python3 generateMetrics.py --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/  > nosql-stats-ind.txt 
python3 generateMetrics.py --project-list xss_projects.txt --working-dir /mnt/wrk/xss/  > xss-stats-ind.txt 

## same procedure with combined scores
# compute combined scores
python3 misc/combinescores.py --project-dir /persistent/experiments/results/sql/ --query-name SqlInjectionWorse
python3 misc/combinescores.py --project-dir /persistent/experiments/results/nosql/ --query-name NosqlInjectionWorse
python3 misc/combinescores.py --project-dir /persistent/experiments/results/xss/ --query-name DomBasedXssWorse

# clean Metrics brqs 
sh ./cleanMetrics.sh

# now recompute using combined stats 
./run-Sql-combined.sh --kind snk $*
./run-Sql-combined.sh --kind src $*
./run-Sql-combined.sh --kind san $*
./run-NoSql-combined.sh --kind snk $*
./run-NoSql-combined.sh --kind src $*
./run-NoSql-combined.sh --kind san $*
./run-Xss-combined.sh- -kind snk $*
./run-Xss-combined.sh- -kind src $*
./run-Xss-combined.sh- -kind san $*

# now compute generate combined  stats 
python3 generateMetrics.py --project-list sqlinjection_projects.txt --working-dir /mnt/wrk/sql/ --combined > sql-stats-combined.txt 
python3 generateMetrics.py --project-list nosqlinjection_projects.txt --working-dir /mnt/wrk/nosql/ --combined > nosql-stats-combined.txt 
python3 generateMetrics.py --project-list xss_projects.txt --working-dir /mnt/wrk/xss/ --combined > xss-stats-combined.txt 
