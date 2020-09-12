#!/bin/bash

PROJECT_SLUG=$1

if [[ $PROJECT_SLUG == "" ]]; then
        echo "Missing project slug"
        exit 1
fi

# Clean codeql project cache
codeql database cleanup --mode brutal output/$PROJECT_SLUG

# Clean propgraph working diretories
rm -rf output/$PROJECT_SLUG/results/*
rm -rf data/$PROJECT_SLUG/results/*
rm -rf logs/
rm -rf results/*
rm -rf constraints/*
rm -rf models/$PROJECT_SLUG/*
