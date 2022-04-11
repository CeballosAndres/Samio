#!/bin/bash
aws_sam_path=".aws-sam/build/${@:1}"

# Commands
p_sam_build="sam build --cached"
p_start_api="sam local start-api"

# Check fswatch
if ! command -v fswatch &>/dev/null; then
	echo "You need to install fswatch."
	echo "With 'brew install fswatch' on Mac or 'apt install fswatch' on Linux."
	exit 1
fi

run_process() {
	echo "Samio: ${1}"
	if $1; then
		echo "Done!"
	else
		echo "Samio: stopped!"
		exit 1
	fi
}

run_process "$p_sam_build"

(
	trap 'kill 0' SIGINT
	run_process "$p_start_api" &
	fswatch --event Created --event Updated --event Renamed -e ".aws-sam" -e ".git" -e ".*.tmp$" -e ".*~$" -e ".*4913$" --e ".*.swx$" e ".*.swp$" . | xargs -n 1 -I{} ~/.samio/scripts/build.sh {} "$aws_sam_path"
)
