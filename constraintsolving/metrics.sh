#!/usr/bin/env bash
cql='/mnt/c/Users/saika/projects/codeql-2.2.0/codeql.exe'
qlsrc='C:/Users/saika/projects/ql/javascript/ql/src/TSM/metrics-src.ql'
qlsnk='C:/Users/saika/projects/ql/javascript/ql/src/TSM/metrics-snk.ql'
qlsan='C:/Users/saika/projects/ql/javascript/ql/src/TSM/metrics-san.ql'
db="C:/Users/saika/projects/ql/constraintsolving/databases/projects/remoteexec/build/$1"
query="CommandInjection"

project_name=$(basename "$1")
size="1"
mkdir -p results/${project_name}/${query}-${size}
#$cql database analyze $db $qlsrc -j 3  --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url "$db/results/codeql-javascript/metrics-src.bqrs" --result-set predictionsSource --format=csv --output=results/${project_name}/${query}-${size}/${project_name}-src-preds.prop.csv
#$cql database analyze $db $qlsnk -j 4 --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url "$db/results/codeql-javascript/metrics-snk.bqrs" --result-set predictionsSink --format=csv --output=results/${project_name}/${query}-${size}/${project_name}-snk-preds-epf.prop.csv
#$cql database analyze $db $qlsan -j 4  --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url "$db/results/codeql-javascript/metrics-san.bqrs" --result-set predictionsSanitizer --format=csv --output=results/${project_name}/${query}-${size}/${project_name}-san-preds.prop.csv

$cql database analyze $db $qlsnk -j 4 --format=csv --rerun --output=logs/js-results.csv --logdir=logs
$cql bqrs decode --entities=string,url "$db/results/codeql-javascript/metrics-snk.bqrs" --result-set isRCE --format=csv --output=results/${project_name}/${query}-${size}/${project_name}-snk-preds.prop.csv
