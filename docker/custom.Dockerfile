FROM alpine:edge

RUN apk update
RUN apk add --no-cache --update \
   git build-base make coreutils curl wget unzip tar \
   bash fish neovim file fd sed ripgrep nodejs \
   npm go

# setup rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install neovim helpers
RUN mkdir ~/.npm-global && npm config set prefix '~/.npm-global'
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="/root/.npm-global/bin:${PNPM_HOME}:${PATH}"
RUN npm i -g pnpm

# setup working directory
WORKDIR /root/.config/nvim
COPY ../ .
RUN scripts/reset.sh

WORKDIR /root/.config/nvim/scripts/nvim-utils
RUN cargo build --release

WORKDIR /root/.config/nvim
