#!/bin/bash

function usage {
    echo "usage"
}

function clean_exercise {
    rm -rf Cargo.* src target tests doc .exercism
}

function link_files {
    clean_exercise

    ln -s exercism-workspace/rust/$1/Cargo.toml Cargo.toml
    ln -s exercism-workspace/rust/$1/src src
    ln -s exercism-workspace/rust/$1/tests tests
    ln -s exercism-workspace/rust/$1/.exercism .exercism
    mkdir doc
    ln -s exercism-workspace/rust/$1/HELP.md doc/HELP.md
    ln -s exercism-workspace/rust/$1/README.md doc/README.md
}

function setup_exercise {
    echo "Downloading exercise: $1 from exercism..."
    exercism download --exercise=$1 --track=rust

    link_files $1
}

function submit_exercise {
    exercism submit src/*.rs Cargo.toml
}

function configure_workspace {
    if [ ! -d ./exercism-workspace ]; then
        mkdir exercism-workspace
    fi

    exercism configure --token $1 --workspace ./exercism-workspace
}

function parse_args {
    OPTS=`getopt -o hl:c:Ce:s --long help,link:,configure:,clean,exercise:,submit -n 'exercism-setup' -- "$@"`

    eval set -- "$OPTS"

    if [ $? != 0 ] ; then
        echo "invalid options" >&2 ;
        exit 1 ;
    fi

    while true; do
        case "$1" in
                -h | --help)      usage; exit;;
                -c | --configure) configure_workspace $2; exit;;
                -C | --clean)     clean_exercise; exit;;
                -e | --exercise)  setup_exercise $2; shift; shift;;
                -l | --link)      link_files $2; shift; shift;;
                -s | --submit)    submit_exercise; shift; shift;;
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