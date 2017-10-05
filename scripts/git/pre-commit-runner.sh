#!/usr/bin/env bash -e

# Path relative to .git/hooks/
APP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && cd .. && pwd )/"
source "$APP_HOME/scripts/git/pre-commit.sh"
