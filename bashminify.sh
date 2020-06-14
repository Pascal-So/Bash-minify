#!/bin/bash

# Bashminify

# minify bash scripts

function print_error {
	echo -e "\033[0;31mERROR\033[0m:" "$@" >&2
}

input_file=$1
if [[ -z "$input_file" ]]; then
	print_error "Expected 1 argument"
	exit 1
fi

if [[ ! -r "$input_file" ]]; then
	print_error "Permission denied on '$input_file'. Either it does not exist or you do not have permission to read it"
	exit 1
fi

source expand_source.sh

function check_eof {
	line=$1
	inside_eof=$2

	is_eof_begin=$(echo "$line" | grep -E '<<\s*EOF')
	if [[ -n "$is_eof_begin" ]]; then
		inside_eof=true
	else
		is_eof_end=$(echo "$line" | grep -E '^\s*EOF')
		if [[ -n "$is_eof_end" ]]; then
			inside_eof=false
		fi
	fi

	echo $inside_eof
}

function strip_comments_and_white_spaces {
	sed -E -e 's/^\s+//' -e 's/\s+$//' -e '/^#.*$/d' -e '/^\s*$/d'
}

function trim_white_spaces {
	sed -E -e 's/^\s+//' -e 's/\s+$//'
}

function use_minimal_function_header {
	sed -E 's/function ([a-zA-Z0-9_]*) \{/\1 () {/'
}

grep --color=never -m 1 '#!' "$input_file"

{ IFS=$'\n'
	inside_eof=false
	expand_source "$input_file" | while read -r line; do
		inside_eof=$(check_eof "$line" "$inside_eof")
		if [[ "$inside_eof" == "false" ]]; then
			echo "$line" |
				strip_comments_and_white_spaces |
				use_minimal_function_header
		else
			echo "$line"
		fi
	done
}
