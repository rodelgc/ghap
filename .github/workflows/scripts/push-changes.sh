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

# Retry pulling and pushing changes when it failed due to race condition,
# like when 2 PR's are trying to push their reports at almost the same time.
# Retry only for a maximum of 10 tries.
for i in {1..10}; do

    echo "Attempting to push changes..."
    
    git pull --rebase
    git push

    EXIT_CODE=$(echo $?)

    if [[ $EXIT_CODE -eq 0 ]]; then
        break
    else
        echo "Retrying in 10 sec..."
        sleep 10
    fi
done
