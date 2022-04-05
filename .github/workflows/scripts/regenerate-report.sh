#!/usr/bin/env bash

#
# This script adds the new test results to this repo.
# This will create history trend if previous reports exist.
#

# Folder in the repo where new report will be generated.
PR_REPORT_PATH='$GITHUB_WORKSPACE/repo/pr/$PR_NUMBER'

# Folder in the repo containing all previous files of allure-results.
# Contents of allure-results folder from the new report will be added here.
PR_RESULTS_PATH='$GITHUB_WORKSPACE/repo/pr/$PR_NUMBER-results'

if [[ -d "$PR_REPORT_PATH" ]]; then

    # PR has previous reports.
    # Combine them with downloaded test report to create history trend.
    mkdir -p $PR_RESULTS_PATH/history
    cp -r $DOWNLOAD_PATH/allure-report/history/* $PR_RESULTS_PATH/history
    cp -r $DOWNLOAD_PATH/allure-results/* $PR_RESULTS_PATH

else

    # Create PR's first test report.
    mkdir -p $PR_REPORT_PATH
    mkdir -p $PR_RESULTS_PATH
    cp -r $DOWNLOAD_PATH/allure-results/* $PR_RESULTS_PATH

fi

# Regenerate the report.
allure generate --clean $PR_RESULTS_PATH --output $PR_REPORT_PATH
