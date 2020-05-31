#!/usr/bin/env bash
pwd
cql='/mnt/c/Users/saika/projects/codeql/codeql.exe'
#cql='/mnt/c/Users/saika/AppData/Roaming/Code/User/globalStorage/github.vscode-codeql/distribution1/codeql/codeql.exe'
db='C:/Users/saika/projects/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675'
bqrsfile='C:/Users/saika/projects/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/results/codeql-javascript/PropagationGraph.bqrs'

#db='C:/Users/saika/apache_js/apache_hadoop_f43a152'
#bqrsfile='C:/Users/saika/apache_js/apache_hadoop_f43a152/results/codeql-javascript/PropagationGraph.bqrs'
ql='C:/Users/saika/projects/ql/javascript/ql/src/PropagationGraph.ql'
sourceql='C:\Users\saika\projects\ql\javascript\ql\src\Sources.ql'
sourcebqps="$db/results/codeql-javascript/Sources.bqrs"
sinksql='C:\Users\saika\projects\ql\javascript\ql\src\Sinks.ql'
sinksbqps="$db/results/codeql-javascript/Sinks.bqrs"
sanitizersql='C:\Users\saika\projects\ql\javascript\ql\src\Sanitizers.ql'
sanitizersbqps="$db/results/codeql-javascript/Sanitizers.bqrs"
#$cql database analyze $db $sourceql --format=csv --rerun --output=js-analysis/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $sourcebqps --format=csv --output=data/eclipse_orion/eclipse_orion-src.prop.csv
$cql database analyze $db $sinksql --format=csv --rerun --output=js-analysis/js-results.csv --logdir=logs
$cql bqrs decode --entities=string,url $sinksbqps --format=csv --output=data/eclipse_orion/eclipse_orion-sinks.prop.csv
$cql database analyze $db $sanitizersql --format=csv --rerun --output=js-analysis/js-results.csv --logdir=logs
$cql bqrs decode --entities=string,url $sanitizersbqps --format=csv --output=data/eclipse_orion/eclipse_orion-sanitizers.prop.csv
exit 0

$cql database analyze $db $ql --format=csv  --output=js-analysis/js-results.csv --logdir=logs
#$cql bqrs decode --entities=string,url $bqrsfile --result-set tripleWAtleastOneRep --format=csv --output=data/hadoop/hadoop-triple-at1.prop.csv
$cql bqrs decode --entities=string,url $bqrsfile --result-set tripleWAtleastOneRep --format=csv --output=data/eclipse_orion/eclipse_orion-triple.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set triple --format=csv --output=data/hadoop/hadoop-triple.prop.csv
#$cql bqrs decode --entities=string,url $bqrsfile --result-set eventToRep --format=csv --output=data/hadoop/hadoop-eventToReps-at1.prop.csv
$cql bqrs decode --entities=string,url $bqrsfile --result-set eventToRep --format=csv --output=data/eclipse_orion/eclipse_orion-eventToReps-at1.prop.csv