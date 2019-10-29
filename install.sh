#!/usr/bin/env bash

## Checking for curl.
echo -n '[INFO] Checking for curl...'
if ! type curl >/dev/null 2>&1; then
  echo -e '\n[ERROR] This script requires curl. Exiting.'
  exit 1
fi
echo 'OK'

## Checking for git.
echo -n '[INFO] Checking for git...'
if ! type git >/dev/null 2>&1; then
  echo -e '\n[ERROR] This script requires git. Exiting.'
  exit 1
fi
echo 'OK'

## Checking for tar.
echo -n '[INFO] Checking for tar...'
if ! type tar >/dev/null 2>&1; then
  echo -e '\n[ERROR] This script requires tar. Exiting.'
  exit 1
fi
echo 'OK'

## Checking for optional zsh.
echo -n '[INFO] Checking for zsh...'
if type zsh >/dev/null 2>&1; then
  if ! [[ $SHELL =~ "zsh" ]]; then
    echo -e '\n[INFO] You are not using zsh, running chsh (cancelable).'
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      chsh -s "$(which zsh | head -n1)"
    fi
  else
    echo 'OK'
  fi
else
  echo -e '\n[WARNING] zsh not installed.'
fi

## Moving to home directory for installation.
echo -n '[INFO] Moving to home directory...'
cd $HOME || exit 1
echo 'OK'

## Check/create .zsh directory.
echo -n '[INFO] Creating .zsh directory...'
if [[ ! -e .zsh ]]; then 
  mkdir .zsh || exit 1
  echo 'OK'
elif [[ ! -d .zsh ]]; then
  echo -e "\n[ERROR] .zsh already exists and it's not a directory. Exiting."
  exit 1
fi

## Install fzf binary.
echo -n '[INFO] Checking for fzf binnary...'
if ! type fzf >/dev/null 2>&1; then
  echo 'Not found'
  if [[ -e .zsh/bin/fzf ]]; then
    echo '[WARNING] .zsh/bin/fzf already exists but is not in the the current path.'
  else
    echo '[INFO] Installing fzf (only linux/macOS amd64 are supported).'
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      distro="$(uname -s | tr 'A-Z' 'a-z')"
      if [[ $distro == *linux* ]]; then
        distro="linux"
      elif [[ $distro == *darwin* ]]; then
        distro="darwin"
      else
        echo "[WARNING] Cannot use the following distro for fzf installation: $distro. Skipping fzf installation."
        distro="none"
      fi

      if [[ ! -e .zsh/bin ]]; then
        mkdir .zsh/bin
      elif [[ ! -d .zsh/bin ]]; then
        echo "[ERROR] .zsh/bin already exists but it's not a directory. Skipping fzf installation."
        distro="none"
      fi

      if [[ "$distro" != "none" ]]; then
        version=$(curl -sI 'https://github.com/junegunn/fzf-bin/releases/latest' | grep Location: | rev | cut -d/ -f1 | rev | tr -d '\n\r')
        curl -sL "https://github.com/junegunn/fzf-bin/releases/download/$version/fzf-$version-${distro}_amd64.tgz" | tar -xzf - -C .zsh/bin || exit 1
      fi
    fi
  fi
else
  echo 'OK'
fi

## Download grml .zshrc.
echo -n '[INFO] Downloading .zshrc from grml...'
if [[ -f .zshrc ]]; then
  dest=".zshrc.$(date +%F).old"
  echo -e "\n[WARNING] .zshrc already exits. Moving it to $dest."
  mv .zshrc $dest || exit 1
  curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1
else
  curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1
  echo 'OK'
fi

## Download .zshrc.local.
echo -n '[INFO] Downloading .zshrc.local from GitHub...'
if [[ -f ".zshrc.local" ]]; then
  dest=".zshrc.local.$(date +%F).old"
  echo -e "\n[WARNING] .zshrc.local already exits. Moving it to $dest."
  mv ".zshrc.local" $dest || exit 1
  curl -sLo ".zshrc.local" "https://raw.githubusercontent.com/scotow/zsh-setup/master/local.zsh" || exit 1
else
  curl -sLo ".zshrc.local" "https://raw.githubusercontent.com/scotow/zsh-setup/master/local.zsh" || exit 1
  echo 'OK'
fi

## Download zsh-autosuggestions.
echo -n '[INFO] Cloning zsh-autosuggestions from GitHub...'
git clone -q https://github.com/zsh-users/zsh-autosuggestions .zsh/zsh-autosuggestions || exit 1
echo 'OK'

## Download syntax-highlighting.
echo -n '[INFO] Cloning syntax-highlighting from GitHub...'
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting .zsh/zsh-syntax-highlighting || exit 1
echo 'OK'

## Download fzf plugins.
for file in fzf-key-bindings fzf-key-completion; do
  echo -n "[INFO] Downloading $file from Github..."
  if [[ -f ".zsh/$file.zsh" ]]; then
    dest=".zsh/$file.zsh.$(date +%F).old"
    echo -e "\n[WARNING] .zsh/$file.zsh already exits. Moving it to $dest."
    mv ".zsh/$file.zsh" $dest || exit 1
    curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
  else
    curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
    echo 'OK'
  fi
done

echo -e '\n[INFO] Installation complete. Restart your shell or run "exec zsh" to apply.'