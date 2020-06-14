function expand_source {
	if [[ $# -ne 1 ]]; then
		print_error "Bashminify error in \"expand_source\", nr. of arguments"
	fi

	local filename=$1
	if [[ ! -f "${filename}" ]]; then
		print_error "File \"${filename}\" does not exist."
		exit 1
	fi

	if [[ ! -r "${filename}" ]]; then
		print_error "Can't read file \"${filename}\"."
		exit 1
	fi

	while read -r line; do
		command="$(echo $line | cut -d" " -f1)"
		if [[ "$command" == "source" || "$command" == "." ]]; then
			included_file=$(echo $line | cut -d" " -f 2)
			expand_source "${included_file}"
		else
			echo "$line"
		fi
	done <"${filename}"
}
