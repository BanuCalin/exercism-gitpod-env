#!/bin/bash

function usage {
    echo "usage"
}

function clean_exercise {
    rm -rf Cargo.* src target tests doc .exercism
}

function setup_exercise {
    clean_exercise

    mkdir exercism-workspace
    exercism configure -w ./exercism-workspace

    echo "Downloading exercise: $1 from exercism..."
    EX_PATH=$(exercism download --exercise=$1 --track=rust 2> /dev/null)

    mv exercism-workspace/rust/*/Cargo.toml .
    mv exercism-workspace/rust/*/src .
    mv exercism-workspace/rust/*/tests .
    mv exercism-workspace/rust/*/.exercism .
    mkdir doc
    mv exercism-workspace/rust/*/HELP.md doc/
    mv exercism-workspace/rust/*/README.md doc/

    rm -rf exercism-workspace
}

function submit_exercise {
    exercism submit src/*.rs Cargo.toml
}

function configure_token {
    exercism configure --token=$1
}

function parse_args {
    OPTS=`getopt -o hct:e:s: --long help,token:clean,exercise:,submit: -n 'exercism-setup' -- "$@"`

    eval set -- "$OPTS"

    if [ $? != 0 ] ; then
        echo "invalid options" >&2 ;
        exit 1 ;
    fi

    while true; do
        case "$1" in
                -h | --help) usage; exit;;
                -t | --token) configure_token $2; exit;;
                -c | --clean) clean_exercise; exit;;
                -e | --exercise) setup_exercise $2; shift; shift;;
                -s | --submit) submit_exercise $2; shift; shift;;
            --) shift; break;;
            *) break;;
        esac
    done
}

function main {
    # Exit immediately if a command exits with a non-zero status
    set -e
    parse_args $*
}

main $*