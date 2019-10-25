#!/usr/bin/env bash

if ! type curl > /dev/null; then
  echo '[Error] This script requires curl. Exiting.'
  exit 1
fi

if ! type zsh > /dev/null; then
  echo '[Warning] zsh not installed.'
fi


if [[ -f .zshrc ]]; then
  dest=".zshrc.$(date +%F).old"
  echo "[Warning] .zshrc already exits. Moving it to $dest"
  mv .zshrc $dest || exit 1
fi
curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1

for file in 'local' autosuggestions syntax-highlighting fzf-key-bindings fzf-key-completion; do
  if [[ -f ".zshrc.$file" ]]; then
    dest=".zshrc.$file.$(date +%F).old"
    echo "[Warning] .zshrc.$file already exits. Moving it to $dest"
    mv ".zshrc.$file" $dest || exit 1
  fi
  curl -sLo ".zshrc.$file" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
done