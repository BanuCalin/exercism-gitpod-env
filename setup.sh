#!/bin/bash

function usage {
    echo "usage"
}

function clean_exercise {
    rm -rf Cargo.* src target tests doc .exercism
}

function config_launch {
    rm -rf .vscode/launch.json
    cp .vscode/launch.json.base .vscode/launch.json

    TESTS=$(cargo test -- --list --format=terse 2>> /dev/null | awk -F": " '{print $1}')
    # echo $TESTS
    for test in $TESTS; do
        echo "        {"                                                      >> .vscode/launch.json
        echo "            \"type\": \"lldb\","                                >> .vscode/launch.json
        echo "            \"request\": \"launch\","                           >> .vscode/launch.json
        echo "            \"name\": \"Debug($test) EXERCISM_EXERCISE_NAME\"," >> .vscode/launch.json
        echo "            \"cargo\": {"                                       >> .vscode/launch.json
        echo "                \"args\": ["                                    >> .vscode/launch.json
        echo "                    \"test\","                                  >> .vscode/launch.json
        echo "                ],"                                             >> .vscode/launch.json
        echo "                \"filter\": {"                                  >> .vscode/launch.json
        echo "                    \"name\": \"EXERCISM_EXERCISE_NAME\","      >> .vscode/launch.json
        echo "                    \"kind\": \"test\""                         >> .vscode/launch.json
        echo "                }"                                              >> .vscode/launch.json
        echo "            },"                                                 >> .vscode/launch.json
        echo "            \"cwd\": \"\${workspaceFolder}\","                  >> .vscode/launch.json
        echo "            \"args\": ["                                        >> .vscode/launch.json
        echo "                \"$test\","                                     >> .vscode/launch.json
        echo "                \"--include-ignored\","                         >> .vscode/launch.json
        echo "            ]"                                                  >> .vscode/launch.json
        echo "        },"                                                     >> .vscode/launch.json
    done
    sed -i "s/EXERCISM_EXERCISE_NAME/$1/" .vscode/launch.json
    echo "    ]" >> .vscode/launch.json
    echo "}" >> .vscode/launch.json
}

function link_files {
    clean_exercise

    ln -s exercism-workspace/rust/$1/Cargo.toml Cargo.toml
    ln -s exercism-workspace/rust/$1/src src
    ln -s exercism-workspace/rust/$1/tests tests
    ln -s exercism-workspace/rust/$1/.exercism .exercism
    mkdir doc
    # TODO If we link the md files, we get an error in vscode
    cp exercism-workspace/rust/$1/HELP.md doc/HELP.md
    cp exercism-workspace/rust/$1/README.md doc/README.md

    config_launch $1
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
    OPTS=`getopt -o hl:c:Ce:s --long help,link:,configure:,clean,exercise:,submit -n 'setup' -- "$@"`

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