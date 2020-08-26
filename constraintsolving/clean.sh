#!/bin/bash

PROJECT_SLUG=$1
rm -rf output/$PROJECT_SLUG/results/*
rm -rf logs/
rm -rf results/*
rm -rf models/$PROJECT_SLUG/*