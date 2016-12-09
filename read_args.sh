# READ ARGS

# parse the command line arguments and handle usage errors
# Pascal Sommer, 2016

function help {
    echo "Usage: bashminify inputfile" >&2
}

if [[ $# -ne 1 ]]; then
    print_error "Expected 1 argument."
    help
    exit 1
fi

if [[ "${1:0:1}" != "-" ]]; then
    input_file=$1
elif [[ "$1" = "-h" ]]; then
    help
    exit 0
else
    print_error "Unknown argument"
    exit 1
fi

if [[ -z $input_file ]]; then
    print_error "No input file given."
    help
    exit 1
fi
