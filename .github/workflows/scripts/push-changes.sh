#!/usr/bin/env bash

#
# Pushes the newly generated report to the repo.
#

COMMIT_MESSAGE=""

set_commit_message() {

    case $TEST_TYPE in
    "e2e")
        COMMIT_MESSAGE="Added: E2E test report"
        ;;
    "api")
        COMMIT_MESSAGE="Added: API test report"
        ;;
    esac

    case $TEST_WORKFLOW in
    "daily")
        COMMIT_MESSAGE="$COMMIT_MESSAGE -- Daily build"
        ;;
    "pr")
        COMMIT_MESSAGE="$COMMIT_MESSAGE -- PR $PR_NUMBER"
        ;;
    "release")
        COMMIT_MESSAGE="$COMMIT_MESSAGE -- Release build"
        ;;
    esac

    COMMIT_MESSAGE="$COMMIT_MESSAGE -- Run $RUN_ID"
}

set_commit_message

cd $REPO_PATH
git config user.name github-actions
git config user.email github-actions@github.com
git add .
git commit -m "$COMMIT_MESSAGE"
git pull --ff-only
git push
