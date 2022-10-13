FROM alpine:edge

RUN apk update
# RUN apk add --no-cache git curl wget build-base coreutils tar unzip gzip file g++ nodejs npm ripgrep fd \
#                         make sudo python3-dev bash neovim fish libc-dev openjdk11 fzf
# RUN apk add --update --no-cache cmake automake autoconf libtool pkgconf coreutils unzip gettext-tiny-dev

# install packages
RUN apk add --no-cache git build-base coreutils nodejs npm ripgrep bash fish libc-dev curl wget openjdk11 python3-dev neovim fd sed fzf tar gzip file make sudo zip unzip automake autoconf libtool pkgconf cmake gettext-tiny-dev
RUN ln -sf python3 /usr/bin/python

# install pip
RUN python3 -m ensurepip

# install neovim helpers
RUN npm i -g neovim ls_emmet
RUN pip3 install --no-cache-dir --upgrade pip pynvim

# setup rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# setup working directory
WORKDIR /root/.config/nvim
