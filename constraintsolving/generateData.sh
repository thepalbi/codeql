#!/usr/bin/env bash

# ./generateData.sh [database path]
# generates propagation graph triples and known sources/sinks/sanitizers

# Edit the following environment variables based on your environment
#CODEQL= path to `codelql` bynary (e.g., `/home/tools/semmle/codeql-cli/codeql/codeql`)
#CODEQL_SOURCE_ROOT=  path to the `ql` source folder  root (e.g.,`/home/dev/microsoft/ql`)
#QUERY= query type(e.g.,`Xss.ql`)

python3 -m generation.main $1