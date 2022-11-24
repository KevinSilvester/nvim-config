FROM alpine:edge

RUN apk update
RUN apk add --no-cache \
   git build-base make coreutils curl wget unzip tar gzip \
   bash fish neovim file fd sed ripgrep python3-dev nodejs \
   npm viu go

RUN ln -sf python3 /usr/bin/python

# install pip
RUN python3 -m ensurepip

# setup rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN cargo install --locked code-minimap

# install neovim helpers
RUN mkdir ~/.npm-global && npm config set prefix '~/.npm-global'
ENV PATH="/root/.npm-global/bin:${PATH}"
RUN npm i -g neovim ls_emmet tree-sitter-cli
RUN pip3 install --no-cache-dir --upgrade pip pynvim

# setup working directory
WORKDIR /root/.config/nvim
