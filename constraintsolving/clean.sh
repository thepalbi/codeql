#!/bin/bash

PROJECT_SLUG=$1
rm -rf logs/
rm -rf models/$PROJECT_SLUG/*
rm -frv /mnt/wrk/$PROJECT_SLUG/constraints/* 
rm -frv /mnt/wrk/$PROJECT_SLUG/models/*  
rm -frv /persistent/experiments/results/$PROJECT_SLUG/*