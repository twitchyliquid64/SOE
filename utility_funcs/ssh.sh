#!/bin/bash

#@function git-push-ssh
#@description Performs a git push with a specific ssh key
#@usage $1 Path to specific ssh key.
#@usage $2 Remaining arguments to call git push with.
function git-push-ssh () {
    keypath="$1"
    shift
    GIT_SSH_COMMAND="ssh -i ${keypath}" git push "$@"
}

#@function git-ssh
#@description Performs a git function with a specific ssh key
#@usage $1 Path to specific ssh key.
#@usage $2 Remaining arguments to call git with.
function git-ssh () {
    keypath="$1"
    shift
    GIT_SSH_COMMAND="ssh -i ${keypath}" git "$@"
}
