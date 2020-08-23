#!/usr/bin/env bash
# ./generateData.sh [database path]
# generates propagation graph triples and known sources/sinks/sanitizers

# Edit the following environment variables based on your environment
#CODEQL= path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli/codeql/codeql`)
#CODEQL_SOURCE_ROOT=  path to the `ql` source folder  root (e.g.,`/home/dev/microsoft/ql`)
#QUERY= query type(e.g.,`Xss.ql`)

#######################################
codeql_source_root=$CODEQL_SOURCE_ROOT
cql=$CODEQL
# query type
query=$QUERY
# can either be -small (using reps with <5 occurences) or -large (all reps)
# this helps differentiate the filenames
reptype="-small"

#########################################


db=$(echo "${codeql_source_root}/constraintsolving/$1")
project_name=$(basename "$1")
echo "$db"
echo ">>$project_name"

# location of bqrs file
bqrsfile="$db/results/codeql-javascript/PropagationGraph.bqrs"
echo "$bqrsfile"

mkdir -p data/${project_name}


ql="${codeql_source_root}/javascript/ql/src/PropagationGraph.ql"
sourceql="${codeql_source_root}/javascript/ql/src/Sources-${query}.ql"
sourcebqps="$db/results/codeql-javascript/Sources.bqrs"
sinksql="${codeql_source_root}/javascript/ql/src/Sinks-${query}.ql"
sinksbqps="$db/results/codeql-javascript/Sinks.bqrs"
sanitizersql="${codeql_source_root}/javascript/ql/src/Sanitizers-${query}.ql"
sanitizersbqps="$db/results/codeql-javascript/Sanitizers.bqrs"


function generate() {
  echo Analyzing database $2	$3
  $1 database analyze $2 $3 --format=csv --output=logs/js-results.csv --logdir=logs
  echo Executing bqrs decode on $4 and $5
  $1 bqrs decode --entities=string,url $4 --result-set $5 --format=csv --output=$6
}

# generates sources/sinks/sanitizers for given query
generate $cql $db $sourceql $sourcebqps  source${query}Classes data/${project_name}/${project_name}-src-${query}.prop.csv
generate $cql $db $sinksql $sinksbqps sink${query}Classes data/${project_name}/${project_name}-sinks-${query}.prop.csv
generate $cql $db $sanitizersql $sanitizersbqps sanitizer${query}Classes data/${project_name}/${project_name}-sanitizers-${query}.prop.csv

# generates prop graph data
generate $cql $db $ql $bqrsfile tripleWRepID data/${project_name}/${project_name}-triple-id${reptype}.prop.csv
generate $cql $db $ql $bqrsfile eventToConcatRep data/${project_name}/${project_name}-eventToConcatRep${reptype}.prop.csv


