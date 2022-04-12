#!/usr/bin/env bash

#
# This script adds the new test results to this repo.
# This will create history trend if previous reports exist.
#

# Root directory of all reports (files in allure-report folder).
REPORT_ROOT="$REPO_PATH/docs"

# Root directory of all data files (files in the allure-results folder).
DATA_ROOT="$REPO_PATH/data"

# Folder in the repo where the new report (containing history trend) will be generated.
REPORT_PATH=""

# Folder that contains all previous data.
# Contents of newly downloaded "allure-results" folder will be placed here.
DATA_PATH=""

# Set the report and data paths
set_paths() {

    if [[ $TEST_WORKFLOW == "pr" ]]; then
        REPORT_PATH="$REPORT_ROOT/$TEST_WORKFLOW/$PR_NUMBER/$TEST_TYPE"
        DATA_PATH="$DATA_ROOT/$TEST_WORKFLOW/$PR_NUMBER/$TEST_TYPE"
    else
        REPORT_PATH="$REPORT_ROOT/$TEST_WORKFLOW/$TEST_TYPE"
        DATA_PATH="$DATA_ROOT/$TEST_WORKFLOW/$TEST_TYPE"
    fi
}

# Provides an appropriate title, instead of the default "Allure Report".
set_report_title() {

    REPORT_TITLE=""

    case $TEST_TYPE in
    "e2e")
        REPORT_TITLE="WooCommerce E2E"
        ;;
    "api")
        REPORT_TITLE="WooCommerce REST API"
        ;;
    esac

    case $TEST_WORKFLOW in
    "daily")
        REPORT_TITLE="$REPORT_TITLE - Daily smoke test"
        ;;
    "pr")
        REPORT_TITLE="$REPORT_TITLE - PR $PR_NUMBER"
        ;;
    "release")
        REPORT_TITLE="$REPORT_TITLE - Release"
        ;;
    esac

    # HTML Title
    sed -i "s/Allure Report/$REPORT_TITLE/g" $REPORT_PATH/index.html

    # Overview page header
    sed -i "s/Allure Report/$REPORT_TITLE/g" $REPORT_PATH/widgets/summary.json
}

combine_new_report_with_existing() {
    if [[ -f "$REPORT_PATH/index.html" ]]; then

        # The test has previous report.
        # Combine it with newly downloaded one to create history trend.
        mkdir -p $DATA_PATH/history
        cp -r $DOWNLOAD_PATH/allure-report/history/* $DATA_PATH/history
        cp -r $DOWNLOAD_PATH/allure-results/* $DATA_PATH

    else

        # Create the first report.
        mkdir -p $REPORT_PATH
        mkdir -p $DATA_PATH
        cp -r $DOWNLOAD_PATH/allure-results/* $DATA_PATH

    fi
}

set_paths

combine_new_report_with_existing

# Regenerate the report.
allure generate --clean $DATA_PATH --output $REPORT_PATH

# Add front matter to index.html.
# Otherwise, Jekyll will not recognize it as a page, but rather as a static asset only.
# A consequence is that if it's a test report from a PR, it will not show up on the "Pull requests" section in the homepage.
sed -i "1s/^/---\n---\n/" "$REPORT_PATH/index.html"

set_report_title
