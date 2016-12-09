#!/bin/bash

# Bashminify

# minify bash scripts
# Pascal Sommer, 2016

set -u

function print_error {
    echo -e "\033[0;31mERROR\033[0m:" $@ >&2
}

source read_args.sh

source expand_source.sh

function strip_comments_and_whitespace {
    sed -e '/^\s*$/d' -e '/^#.*$/d'
}

expand_source "${input_file}" | strip_comments_and_whitespace
