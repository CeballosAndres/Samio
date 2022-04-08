#!/bin/bash
file_name=$1
path=$(pwd)
base_name=$(basename "$file_name")

if [[ -f "$file_name" ]]; then
	# echo "${1} changed"
	if [[ "$base_name" = "requirements.txt" ]]; then
		sam build
	else
		cp -f "$1" "${path}/.aws-sam/build/LambdaCrud/${base_name}"
	fi
fi

if [[ -d "$1" ]]; then
	sam build --cached
fi
