#!/usr/bin/env bash

if ! type curl > /dev/null; then
  echo '[ERROR] This script requires curl. Exiting.'
  exit 1
fi

if ! type git > /dev/null; then
  echo '[ERROR] This script requires git. Exiting.'
  exit 1
fi

if type zsh > /dev/null; then
  if ! [[ $SHELL =~ "zsh" ]]; then
    read -p '[INFO] You are not using zsh, do you want to change now? [y/N]' -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      chsh -s "$(which zsh)"
    fi
  fi
else
  echo '[WARNING] zsh not installed.'
fi

cd $HOME || exit 1

if [[ ! -e .zsh ]]; then
  mkdir .zsh
elif [[ ! -d .zsh ]]; then
  echo "[ERROR] .zsh already exists and it's not a directory. Exiting."
  exit 1
fi

if [[ -f .zshrc ]]; then
  dest=".zshrc.$(date +%F).old"
  echo "[WARNING] .zshrc already exits. Moving it to $dest."
  mv .zshrc $dest || exit 1
fi
curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1

if [[ -f ".zshrc.local" ]]; then
    dest=".zshrc.local.$(date +%F).old"
    echo "[WARNING] .zshrc.local already exits. Moving it to $dest."
    mv ".zshrc.local" $dest || exit 1
  fi
curl -sLo ".zshrc.local" "https://raw.githubusercontent.com/scotow/zsh-setup/master/local.zsh" || exit 1

git clone https://github.com/zsh-users/zsh-autosuggestions .zsh/zsh-autosuggestions || exit 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting .zsh/zsh-syntax-highlighting || exit 1

for file in fzf-key-bindings fzf-key-completion; do
  if [[ -f ".zsh/$file.zsh" ]]; then
    dest=".zsh/$file.zsh.$(date +%F).old"
    echo "[WARNING] .zsh/$file.zsh already exits. Moving it to $dest."
    mv ".zsh/$file.zsh" $dest || exit 1
  fi
  curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
done