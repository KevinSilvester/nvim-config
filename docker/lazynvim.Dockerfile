FROM alpine:edge

RUN apk update
RUN apk add --no-cache \
   git lazygit build-base make coreutils curl wget unzip tar gzip \
   bash fish neovim file fd sed ripgrep nodejs npm alpine-sdk

# install neovim helpers
RUN mkdir ~/.npm-global && npm config set prefix '~/.npm-global'
ENV PATH="/root/.npm-global/bin:${PATH}"
RUN npm i -g ls_emmet tree-sitter-cli

# setup working directory
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim
WORKDIR /root/.config/nvim
