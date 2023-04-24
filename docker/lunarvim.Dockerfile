FROM alpine:edge

RUN apk update
RUN apk add --no-cache git neovim ripgrep alpine-sdk bash nodejs npm

# setup rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN mkdir ~/.npm-global && npm config set prefix '~/.npm-global'
ENV PATH="/root/.npm-global/bin:${PATH}"
RUN npm i -g neovim ls_emmet tree-sitter-cli

RUN bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
ENV PATH="/root/.local/bin:${PATH}"

# download sample projects to test lsp+cmp
RUN mkdir /root/projects
WORKDIR /root/projects
RUN git clone https://github.com/KevinSilvester/bird.git
RUN git clone https://github.com/KevinSilvester/mern-movie.git

WORKDIR /root/.config/lvim
