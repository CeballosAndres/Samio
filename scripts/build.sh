#!/bin/bash
full_name="$1"
aws_sam_path="$2"
base_name=$(basename "$full_name")
relative_path=$(realpath --relative-to="$(pwd)" "$full_name")

run_process() {
	echo "Samio: ${1}"
	if ! $1; then
		echo "Samio: stopped!"
		exit 0
	fi
}

if [[ -f "$full_name" ]]; then

	case "$base_name" in
	"requirements.txt" | "template.yaml" | "template.yml")
		run_process "sam build --cached"
		;;
	*)
		run_process "cp ${relative_path} ${aws_sam_path}/${relative_path}"
		;;
	esac
elif [[ -d "$full_name" ]]; then
	run_process "sam build --cached"
else
	echo "Nothing to do: ${full_name}"
fi
