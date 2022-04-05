#!/usr/bin/env bash

#
# This script adds the new test report to this repo.
# This will create history trend if previous reports exist.
#

if [[ -d "$PR_PATH" ]]; then

    # PR has previous reports.
    # Combine them with downloaded test report to create history trend.
    mkdir -p $PR_PATH/allure-results/history
    cp -r $DOWNLOAD_PATH/allure-report/history/* $PR_PATH/allure-results/history
    cp -r $DOWNLOAD_PATH/allure-results/* $PR_PATH/allure-results

else

    # PR's first test report.
    # Copy all contents of downloaded test report to a new directory in this repo.
    mkdir -p $PR_PATH
    cp -r $DOWNLOAD_PATH/* $PR_PATH

fi
