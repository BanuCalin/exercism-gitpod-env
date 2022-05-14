#!/bin/bash

function usage {
    echo "usage"
}

function clean_exercise {
    rm -rf Cargo.* src target tests doc .exercism
}

function setup_exercise {
    clean_exercise

    echo "Downloading exercise: $1 from exercism..."
    EX_PATH=$(exercism download --exercise=$1 --track=rust 2> /dev/null)

    ln -s exercism-workspace/rust/*/Cargo.toml Cargo.toml
    ln -s exercism-workspace/rust/*/src src
    ln -s exercism-workspace/rust/*/tests tests
    ln -s exercism-workspace/rust/*/.exercism .exercism
    mkdir doc
    ln -s exercism-workspace/rust/*/HELP.md doc/HELP.md
    ln -s exercism-workspace/rust/*/README.md doc/README.md
}

function submit_exercise {
    exercism submit src/*.rs Cargo.toml
}

function configure_workspace {
    clean_exercise

    rm -rf exercism-workspace
    mkdir exercism-workspace

    exercism configure --token $1 --workspace ./exercism-workspace
}

function parse_args {
    OPTS=`getopt -o hc:Ce:s --long help,configure:,clean,exercise:,submit -n 'exercism-setup' -- "$@"`

    eval set -- "$OPTS"

    if [ $? != 0 ] ; then
        echo "invalid options" >&2 ;
        exit 1 ;
    fi

    while true; do
        case "$1" in
                -h | --help) usage; exit;;
                -c | --configure) configure_workspace $2; exit;;
                -C | --clean) clean_exercise; exit;;
                -e | --exercise) setup_exercise $2; shift; shift;;
                -s | --submit) submit_exercise; shift; shift;;
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