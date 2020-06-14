#!/bin/bash

declare -A already_expanded

function expand_source {
	if [[ $# -ne 1 ]]; then
		print_error "Bashminify error in \"expand_source\", nr. of arguments"
	fi

	local filename
	filename=$(realpath "$1")
	if [[ ! -f "${filename}" ]]; then
		print_error "File \"${filename}\" does not exist."
		exit 1
	fi

	if [[ ! -r "${filename}" ]]; then
		print_error "Can't read file \"${filename}\"."
		exit 1
	fi

	local base_source_dir
	base_source_dir=$(dirname "$filename")
	while read -r line; do
		command="$(echo "$line" | cut -d" " -f1)"

		if [[ "$command" == "source" || "$command" == "." ]]; then
			include_file="$base_source_dir/$(echo "$line" | cut -d" " -f 2)"

			if [[ "${already_expanded[$include_file]}" == "" ]]; then
				already_expanded[$include_file]=true
				expand_source "$include_file"
			fi
		else
			echo "$line"
		fi
	done <"${filename}"
}
