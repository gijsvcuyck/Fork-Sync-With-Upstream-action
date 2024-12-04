#!/bin/sh

test_target_branch_exists() {
    write_out "y" "TEST"
    write_out -1 "[Verify Target Sync Branch] -> tests 'target_sync_branch' input"
    VERIFY_TARGET_BRANCH=$(git rev-parse --verify "remotes/origin/${INPUT_TARGET_SYNC_BRANCH}")
    write_out "b" "checking existing branches:"
    git branch -a
    if [ -z "${VERIFY_TARGET_BRANCH}" ]; then
        write_out "r" "FAILED - no branch '${INPUT_TARGET_SYNC_BRANCH}' to run action on\nDid you set 'ref' correctly in the checkout step?\n"
    else
        write_out "g" "PASSED\n"
    fi
}

test_upstream_repo_exists() {
    write_out "y" "TEST"
    write_out -1 "[Verify Upstream Sync Repo Exists] -> tests 'upstream_sync_repo' input"
    VERIFY_TARGET_REPO=$(git ls-remote "${UPSTREAM_REPO_URL}" --quiet)

    # var is empty on success, so fail if return value has any data
    if [ -n "${VERIFY_TARGET_REPO}" ]; then
        write_out "r" "FAILED - Upstream repo '${INPUT_UPSTREAM_SYNC_REPO}' not found OR you do not have permission to view it\n"
    else
        write_out "g" "PASSED\n"
    fi

}

test_upstream_branch_exists() {
    write_out "y" "TEST"
    write_out -1 "[Verify Upstream Sync Branch Exists] -> tests 'upstream_sync_branch' input"
    write_out "b" "sending request to ${UPSTREAM_REPO_URL}"
    VERIFY_UPSTREAM_BRANCH=$(git ls-remote "${UPSTREAM_REPO_URL}" "${INPUT_UPSTREAM_SYNC_BRANCH}" --quiet)
    SECOND_TRY=$(git ls-remote "https://test/${UPSTREAM_REPO_URL}.test" "${INPUT_UPSTREAM_SYNC_BRANCH}")
    THIRD_TRY=$(git ls-remote "https://git:olp_4QEdugEqhfiBlN9g4zPVEBkHY43XDT1FSzQZ@git.overleaf.com/64773a530f15bea1ef6bbcce.git/" "${INPUT_UPSTREAM_SYNC_BRANCH}")
    write_out "b" "second attempt: ${SECOND_TRY}"
    write_out "b" "third attempt: ${THIRD_TRY}"

    # var contains the ref on success, so fail if return value is empty
    if [ -z "${VERIFY_UPSTREAM_BRANCH}" ]; then
        write_out "r" "FAILED - no branch '${INPUT_UPSTREAM_SYNC_BRANCH}' found on remote repo\n"
    else
        write_out "g" "PASSED\n"
    fi
}
