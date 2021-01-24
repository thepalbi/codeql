#!/bin/bash
DB_DIRECTORY=$1
DB_ZIP=$2
SOURCES_DIR=$3

rm -rf $DB_DIRECTORY
codeql database create --source-root=$SOURCES_DIR --language=javascript $DB_DIRECTORY
zip -r $DB_ZIP $DB_DIRECTORY