FROM gitpod/workspace-rust:latest

# RUN rustup -V
# RUN rustup toolchain install nightly
# RUN rustup component add rustfmt --toolchain nightly
# RUN rustup component add clippy --toolchain nightly

RUN mkdir -p $HOME/bin
RUN wget -P /tmp https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz
RUN tar -xvf /tmp/exercism-3.0.13-linux-x86_64.tar.gz -C /tmp; cp /tmp/exercism $HOME/bin
ENV PATH=$HOME/bin:$PATH