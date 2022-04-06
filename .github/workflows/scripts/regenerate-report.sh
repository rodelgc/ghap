#!/usr/bin/env bash

#
# This script adds the new test results to this repo.
# This will create history trend if previous reports exist.
#

# Root directory of all reports.
REPORT_ROOT="$REPO_PATH/docs"

# Root directory of all data files.
DATA_ROOT="$REPO_PATH/data"

# Folder in the repo where the new report (containing history trend) will be generated.
REPORT_PATH=""

# Folder that contains all previous data.
# Contents of newly downloaded "allure-results" folder will be placed here.
DATA_PATH=""

# Title of the report as viewed in the browser tab and in the Overview page.
REPORT_TITLE=""

# Sets up values for env vars above, depending on the provided TEST_TYPE and TEST_WORKFLOW.
set_paths() {

    # Determine whether report will be generated in docs/e2e or docs/api folder.
    case $TEST_TYPE in
    'e2e')
        REPORT_ROOT="$REPORT_ROOT/e2e"
        REPORT_TITLE="WooCommerce E2E"
        ;;
    'api')
        REPORT_ROOT="$REPORT_ROOT/api"
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
        REPORT_PATH="$REPORT_ROOT/daily"
        DATA_PATH="$DATA_ROOT/daily"
        REPORT_TITLE="$REPORT_TITLE - Daily Builds"
        ;;
    'pr')
        REPORT_PATH="$REPORT_ROOT/pr/$PR_NUMBER"
        DATA_PATH="$DATA_ROOT/pr/$PR_NUMBER"
        REPORT_TITLE="$REPORT_TITLE - PR $PR_NUMBER"
        ;;
    'release')
        REPORT_PATH="$REPORT_ROOT/release"
        DATA_PATH="$DATA_ROOT/release"
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
    mkdir -p $DATA_PATH/history
    cp -r $DOWNLOAD_PATH/allure-report/history/* $DATA_PATH/history
    cp -r $DOWNLOAD_PATH/allure-results/* $DATA_PATH

else

    # Create the first report.
    mkdir -p $REPORT_PATH
    mkdir -p $DATA_PATH
    cp -r $DOWNLOAD_PATH/allure-results/* $DATA_PATH

fi

# Regenerate the report.
allure generate --clean $DATA_PATH --output $REPORT_PATH

set_report_title
