#!/usr/bin/env bash

#
# This script adds the new test results to this repo.
# This will create history trend if previous reports exist.
#

# The root dir of the report, whether it be the "e2e" or "api" root folder.
ROOT_DIR=""

# Folder in the repo where the new report (containing history trend) will be generated.
REPORT_PATH=""

# Folder that contains all previous results.
# Contents of newly downloaded "allure-results" folder will be placed here.
RESULTS_PATH=""

# Title of the report as viewed in the browser tab and in the Overview page.
REPORT_TITLE=""

# Sets up values for env vars above, depending on the provided TEST_TYPE and TEST_WORKFLOW.
set_paths() {

    # Determine whether report will be generated in `e2e` or `api` root folder.
    case $TEST_TYPE in
    'e2e')
        ROOT_DIR="$REPO_PATH/e2e"
        REPORT_TITLE="WooCommerce E2E"
        ;;
    'api')
        ROOT_DIR="$REPO_PATH/api"
        REPORT_TITLE="WooCommerce REST API"
        ;;
    *)
        echo "You provided a wrong value for TEST_TYPE: \"$TEST_TYPE\""
        echo "Options are: [ e2e | api ]"
        echo "Exiting with code 1."
        exit 1
        ;;
    esac

    # Determine whether report will be in daily, pr, or release folder
    case $TEST_WORKFLOW in
    'daily')
        REPORT_PATH="$ROOT_DIR/daily"
        RESULTS_PATH="$ROOT_DIR/daily-results"
        REPORT_TITLE="$REPORT_TITLE - Daily Builds"
        ;;
    'pr')
        REPORT_PATH="$ROOT_DIR/pr/$PR_NUMBER"
        RESULTS_PATH="$ROOT_DIR/pr/$PR_NUMBER-results"
        REPORT_TITLE="$REPORT_TITLE - PR $PR_NUMBER"
        ;;
    'release')
        REPORT_PATH="$ROOT_DIR/release"
        RESULTS_PATH="$ROOT_DIR/release-results"
        REPORT_TITLE="$REPORT_TITLE - Releases"
        ;;

    *)
        echo "You provided a wrong value for TEST_WORKFLOW: \"$TEST_WORKFLOW\""
        echo "Options are: [ daily | pr | release ]"
        echo "Exiting with code 1."
        exit 1
        ;;
    esac

}

# Provides an appropriate title, instead of the default "Allure Report".
set_report_title() {

    # HTML Title
    sed -i "s/Allure Report/$REPORT_TITLE/g" $REPORT_PATH/index.html

    # Overview page
    sed -i "s/Allure Report/$REPORT_TITLE/g" $REPORT_PATH/widgets/summary.json
}

set_paths

if [[ -d "$REPORT_PATH" ]]; then

    # The test has previous reports.
    # Combine them with newly downloaded test report to create history trend.
    mkdir -p $RESULTS_PATH/history
    cp -r $DOWNLOAD_PATH/allure-report/history/* $RESULTS_PATH/history
    cp -r $DOWNLOAD_PATH/allure-results/* $RESULTS_PATH

else

    # Create the first report.
    mkdir -p $REPORT_PATH
    mkdir -p $RESULTS_PATH
    cp -r $DOWNLOAD_PATH/allure-results/* $RESULTS_PATH

fi

# Regenerate the report.
allure generate --clean $RESULTS_PATH --output $REPORT_PATH

set_report_title
