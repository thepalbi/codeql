#!/usr/bin/env bash

# ./generateEventScores.sh [database path]
# generates the resulting scores for each Sink

# Edit the following environment variables based on your environment
#CODEQL= path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli/codeql/codeql`)
#CODEQL_SOURCE_ROOT=  path to the `ql` source folder  root (e.g.,`/home/dev/microsoft/ql`)
#QUERY_TYPE= query type(e.g.,`Xss`)
#QUERY_NAME = query name (e.g, `DomXssWorse`)

python3 -m generation.main --step scores --project-dir "$1"
