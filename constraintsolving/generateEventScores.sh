#!/usr/bin/env bash
# ./generateEventScores.sh [db-path]

cql='/mnt/c/Users/saika/projects/codeql-2.2.0/codeql.exe'
ql='C:/Users/saika/projects/ql/javascript/ql/src/metrics-snk.ql'
bqrsfile="$db/results/codeql-javascript/metrics-snk.bqrs"

db=$(echo "$1")
project_name=$(basename "$1")
echo "$db"
echo "$project_name"

mkdir -p data/${project_name}


$cql database analyze $db $ql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
$cql bqrs decode --entities=string,url $bqrsfile  --result-set getTSMWorseScoresNoSql --format=csv --output=data/${project_name}/${project_name}-tsmworse-ind-avg.prop.csv
$cql bqrs decode --entities=string,url $bqrsfile  --result-set getTSMWorseFilteredNoSql --format=csv --output=data/${project_name}/${project_name}-tsmworse-filtered-avg.prop.csv