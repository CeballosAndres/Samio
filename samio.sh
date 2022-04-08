#!/bin/bash

# Commands
p_sam_build="sam build"
p_start_api="sam local start-api"

# Check fswatch
if ! command -v fswatch &>/dev/null; then
	echo "You need to install fswatch."
	echo "With 'brew install fswatch' on Mac or 'apt install fswatch' on Linux."
	exit 1
fi

run_process() {
	echo "Start: ${1}"
	if $1; then
		echo "Completed: ${1}"
	else
		echo "Process stopped!"
		exit 1
	fi
}

run_process "$p_sam_build"

(
	trap 'kill 0' SIGINT
	run_process "$p_start_api" &
	fswatch -e ".aws-sam" -e ".git" . | xargs -n1 -I{} ~/samio/scripts/build.sh {}
)
