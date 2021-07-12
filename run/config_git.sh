#!/bin/sh

# called by run_action.sh
config_for_action() {
    write_out -1 "Setting git config from input vars. (Skips each config if input is set to 'null'.)"
    get_current_user_config
    set_git_config "${INPUT_GIT_CONFIG_USER}" "${INPUT_GIT_CONFIG_EMAIL}" "${INPUT_GIT_CONFIG_PULL_REBASE}"
    write_out "g" "SUCCESS\n"
}

# store current user config data for reset after action run
get_current_user_config() {
    CURRENT_USER=$(git config --get --default="null" user.name)
    CURRENT_EMAIL=$(git config --get --default="null" user.email)
    CURRENT_PULL_CONFIG=$(git config --get --default="null" pull.rebase)
}

# set action config values
set_git_config() {
    # only set config if user did not set input var to "null"
    if [ "${INPUT_GIT_CONFIG_USER}" != "null" ]; then
        git config user.name "${1}"
    fi

    # only set config if user did not set input var to "null"
    if [ "${INPUT_GIT_CONFIG_EMAIL}" != "null" ]; then
        git config user.email "${2}"
    fi

    git config pull.rebase "${3}"
}

# reset to original user config values
reset_git_config() {
    write_out -1 "Resetting git config to previous settings."

    if [ "${CURRENT_USER}" = "null" ]; then
        git config --unset user.name
    else
        git config user.name "${CURRENT_USER}"
    fi

    if [ "${CURRENT_EMAIL}" = "null" ]; then
        git config --unset user.email
    else
        git config user.email "${CURRENT_EMAIL}"
    fi

    if [ "${CURRENT_PULL_CONFIG}" = "null" ]; then
        git config --unset pull.rebase
    else
        git config pull.rebase "${CURRENT_PULL_CONFIG}"
    fi

    write_out "g" "SUCCESS\n"
}
