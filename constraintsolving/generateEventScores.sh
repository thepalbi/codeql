#!/usr/bin/env bash
# ./generateEventScores.sh [db-path]

cql=$CODEQL
ql=$CODEQL_SOURCE_ROOT/javascript/ql/src/metrics-snk.ql 
query_type=$QUERY_TYPE
query_name=$QUERY_NAME

db=$(echo "$1")
project_name=$(basename "$1")
bqrsfile="$db/results/codeql-javascript/metrics-snk.bqrs"
echo "$db"
echo "$project_name"

mkdir -p data/${project_name}

echo analyzing DB $db $ql
#echo $cql database analyze $db $ql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
$cql database analyze $db $ql --format=csv --rerun --output=logs/js-results.csv --logdir=logs

echo running bqrs decode $bqrsfile
$cql bqrs decode --entities=string,url $bqrsfile  --result-set getTSMWorseScores$query_type --format=csv --output=data/${project_name}/${project_name}-tsmworse-ind-avg.prop.csv
echo running bqrs decode $bqrsfile
$cql bqrs decode --entities=string,url $bqrsfile  --result-set getTSMWorseFiltered$query_type --format=csv --output=data/${project_name}/${project_name}-tsmworse-filtered-avg.prop.csv