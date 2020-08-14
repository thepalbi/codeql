#!/usr/bin/env bash
db=$(echo "C:/Users/saika/projects/ql/constraintsolving/databases/projects/NoSqlInjection/$1")
project_name=$(basename "$1")
echo "$db"
echo "$project_name"

cql='/mnt/c/Users/saika/codeql-cli-atm-home/codeql/codeql.exe'

#bqrsfile="$db/results/codeql-javascript/experimental/adaptivethreatmodeling/NosqlInjectionATM.bqrs"
bqrsfile="$db/results/codeql-javascript/evaluation/NosqlInjectionWorseATM.bqrs"

mkdir -p data/${project_name}
#ql='C:/Users/saika/projects/vscode-codeql-starter/ql/javascript/ql/src/experimental/adaptivethreatmodeling/NosqlInjectionATM.ql'
ql='C:/Users/saika/projects/vscode-codeql-starter/ql/javascript/ql/src/evaluation/NosqlInjectionWorseATM.ql'

$cql database analyze $db $ql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $bqrsfile  --format=csv --output=data/${project_name}/${project_name}-atm.prop.csv
$cql bqrs decode --entities=string,url $bqrsfile  --format=csv --output=data/${project_name}/${project_name}-atm-worse.prop.csv