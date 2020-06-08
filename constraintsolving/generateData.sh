#!/usr/bin/env bash
pwd
#project_name='ampproject_amphtml'
project_name="eclipse_orion"
cql='/mnt/c/Users/saika/projects/codeql-2.2.0/codeql.exe'
#cql='/mnt/c/Users/saika/AppData/Roaming/Code/User/globalStorage/github.vscode-codeql/distribution1/codeql/codeql.exe'
#db='C:/Users/saika/projects/ql/constraintsolving/databases/agiliq_django-blogango_8e6b0f0'
#db='C:/Users/saika/projects/ql/constraintsolving/databases/ampproject_amphtml_b5aa393'
#db='C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675'
db='C:/Users/saika/projects/ql/constraintsolving/databases/projects/eclipse_orion.client_05afd3c'
bqrsfile="$db/results/codeql-javascript/PropagationGraph.bqrs"

mkdir -p data/${project_name}
#db='C:/Users/saika/apache_js/apache_hadoop_f43a152'
#bqrsfile='C:/Users/saika/apache_js/apache_hadoop_f43a152/results/codeql-javascript/PropagationGraph.bqrs'
ql='C:/Users/saika/projects/ql/javascript/ql/src/PropagationGraph.ql'
sourceql='C:\Users\saika\projects\ql\javascript\ql\src\Sources.ql'
sourcebqps="$db/results/codeql-javascript/Sources.bqrs"
sinksql='C:\Users\saika\projects\ql\javascript\ql\src\Sinks.ql'
sinksbqps="$db/results/codeql-javascript/Sinks.bqrs"
sanitizersql='C:\Users\saika\projects\ql\javascript\ql\src\Sanitizers.ql'
sanitizersbqps="$db/results/codeql-javascript/Sanitizers.bqrs"
#$cql database analyze $db $sourceql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $sourcebqps --format=csv --output=data/${project_name}/new/${project_name}-src.prop.csv
#$cql database analyze $db $sinksql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $sinksbqps --format=csv --output=data/${project_name}/new/${project_name}-sinks.prop.csv
#$cql database analyze $db $sanitizersql --format=csv --rerun --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $sanitizersbqps --format=csv --output=data/${project_name}/new/${project_name}-sanitizers.prop.csv
#exit 0

$cql database analyze $db $ql --format=csv  --output=logs/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $bqrsfile --result-set tripleWAtleastOneRep --format=csv --output=data/hadoop/hadoop-triple-at1.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set tripleWAtleastOneRep --format=csv --output=data/${project_name}/${project_name}-triple.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set triple --format=csv --output=data/hadoop/hadoop-triple.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set eventToRep --format=csv --output=data/hadoop/hadoop-eventToReps-at1.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set eventToRep --format=csv --output=data/${project_name}/${project_name}-eventToReps.prop.csv