#! /usr/bin/env bash

rm ~/.config/nvim/.git/hooks/*
rm ~/.config/nvim/scripts/bin/*
touch ~/.config/nvim/scripts/bin/.gitkeep

cd ~/.config/nvim/scripts/nvim-utils

cargo build --release

# copy git hooks
cp target/release/post-merge ~/.config/nvim/.git/hooks/post-merge
cp target/release/pre-push ~/.config/nvim/.git/hooks/pre-push

# copy other binaries
cp target/release/bootstrap ~/.config/nvim/scripts/bin/bootstrap
cp target/release/ts-parsers ~/.config/nvim/scripts/bin/ts-parsers 
