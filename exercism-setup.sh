#!/bin/bash

mkdir -p exercism-cli exercism
cd exercism-cli
wget https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz
tar -xvf exercism-3.0.13-linux-x86_64.tar.gz
mkdir -p $HOME/bin
cp exercism $HOME/bin
$HOME/bin/exercism version