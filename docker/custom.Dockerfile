FROM alpine:edge

RUN apk update
RUN apk add --no-cache --update \
   git build-base make coreutils curl wget unzip tar gzip \
   bash fish neovim file fd sed ripgrep nodejs \
   npm viu go perl pkgconfig openssl-dev

# setup rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install neovim helpers
RUN mkdir ~/.npm-global && npm config set prefix '~/.npm-global'
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="/root/.npm-global/bin:${PNPM_HOME}:${PATH}"
RUN npm i -g pnpm

# setup working directory
COPY ../ /root/.config/nvim
RUN /root/.config/nvim/scripts/reset.sh
WORKDIR /root/.config/nvim
