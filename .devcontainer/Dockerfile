# [Choice] Debian OS version (use bullseye on local arm64/Apple Silicon): buster, bullseye
FROM rust:buster

RUN rustup component add rustfmt
RUN rustup component add clippy

RUN mkdir -p $HOME/bin
RUN wget -P /tmp https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz
RUN tar -xvf /tmp/exercism-3.0.13-linux-x86_64.tar.gz -C /tmp; cp /tmp/exercism $HOME/bin
ENV PATH=$HOME/bin:$PATH
