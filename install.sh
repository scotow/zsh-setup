#!/usr/bin/env bash

## Checking for curl.
if ! type curl >/dev/null 2>&1; then
  echo '[ERROR] This script requires curl. Exiting.'
  exit 1
fi

## Checking for git.
if ! type git >/dev/null 2>&1; then
  echo '[ERROR] This script requires git. Exiting.'
  exit 1
fi

## Checking for tar.
if ! type tar >/dev/null 2>&1; then
  echo '[ERROR] This script requires tar. Exiting.'
  exit 1
fi

## Checking for optional zsh.
if type zsh >/dev/null 2>&1; then
  if ! [[ $SHELL =~ "zsh" ]]; then
    read -p '[INFO] You are not using zsh, do you want to change now? [y/N]' -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      chsh -s "$(which zsh | head -n1)"
    fi
  fi
else
  echo '[WARNING] zsh not installed.'
fi

## Moving to home directory for installation.
cd $HOME || exit 1

## Check/create .zsh directory.
if [[ ! -e .zsh ]]; then
  mkdir .zsh
elif [[ ! -d .zsh ]]; then
  echo "[ERROR] .zsh already exists and it's not a directory. Exiting."
  exit 1
fi

## Check/create .zsh/fzf directory.
if [[ ! -e .zsh/fzf ]]; then
  mkdir .zsh/fzf
elif [[ ! -d .zsh/fzf ]]; then
  echo "[ERROR] .zsh/fzf already exists and it's not a directory. Exiting."
  exit 1
fi

## Install fzf binary.
if ! type fzf >/dev/null 2>&1; then
  if [[ -e .zsh/bin/fzf ]]; then
    echo '[WARNING] .zsh/bin/fzf already exists but is not in the the current path.'
  else
    echo '[INFO] fzf not installed.'
    read -p '[INFO] Do you want to install it in your .zsh/bin directory now (only linux/macOS amd64 are supported) ? [y/N]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      distro="$(uname -s | tr 'A-Z' 'a-z')"
      if [[ $distro == *linux* ]]; then
        distro="linux"
      elif [[ $distro == *darwin* ]]; then
        distro="darwin"
      else
        echo "[ERROR] Cannot use the following distro for fzf installation: $distro."
        exit 1
      fi

      if [[ ! -e .zsh/bin ]]; then
        mkdir .zsh/bin
      elif [[ ! -d .zsh/bin ]]; then
        echo "[ERROR] .zsh/bin already exists but it's not a directory. Exiting."
        exit 1
      fi

      version=$(curl -sI 'https://github.com/junegunn/fzf-bin/releases/latest' | grep Location: | rev | cut -d/ -f1 | rev)
      curl -sL "https://github.com/junegunn/fzf-bin/releases/download/$version/fzf-$version-${distro}_amd64.tgz" | tar -xzf - -C .zsh/bin || exit 1
    fi
  fi
fi

## Download grml .zshrc.
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

git clone -q https://github.com/zsh-users/zsh-autosuggestions .zsh/zsh-autosuggestions || exit 1
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting .zsh/zsh-syntax-highlighting || exit 1

for file in fzf-key-bindings fzf-key-completion; do
  if [[ -f ".zsh/$file.zsh" ]]; then
    dest=".zsh/$file.zsh.$(date +%F).old"
    echo "[WARNING] .zsh/$file.zsh already exits. Moving it to $dest."
    mv ".zsh/$file.zsh" $dest || exit 1
  fi
  curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
done