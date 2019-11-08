#!/usr/bin/env bash

## Colors.
BLUE='\033[0;36m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

## Logs.
INFO="${NC}[${BLUE}INFO${NC}]"
WARN="${NC}[${ORANGE}WARN${NC}]"
ERROR="${NC}[${ORANGE}ERROR${NC}]"
OK="${GREEN}OK${NC}"
NF="${BLUE}Not Found${NC}"

## Checking for curl.
echo -en "$INFO Checking for curl..."
if ! type curl >/dev/null 2>&1; then
  echo -e "\n$ERROR This script requires curl. Exiting."
  exit 1
fi
echo -e "$OK"

## Checking for git.
echo -en "$INFO Checking for git..."
if ! type git >/dev/null 2>&1; then
  echo -e "\n$ERROR This script requires git. Exiting."
  exit 1
fi
echo -e "$OK"

## Checking for tar.
echo -en "$INFO Checking for tar..."
if ! type tar >/dev/null 2>&1; then
  echo -e "\n$ERROR This script requires tar. Exiting."
  exit 1
fi
echo -e "$OK"

## Checking for optional zsh.
echo -en "$INFO Checking for zsh..."
if type zsh >/dev/null 2>&1; then
  if ! [[ $SHELL =~ "zsh" ]]; then
    echo -e "\n$WARN You are not using zsh, change your default shell using \"chsh\" or \"usermod\"."
  else
    echo -e "$OK"
  fi
else
  echo -e "\n$WARN zsh not installed."
fi

## Moving to home directory for installation.
echo -en "$INFO Moving to home directory..."
cd $HOME || exit 1
echo -e "$OK"

## Download grml .zshrc.
echo -en "$INFO Checking for .zshrc..."
if [[ -f .zshrc ]]; then
  dest=".zshrc.$(date +%F).old"
  echo -en "\n$WARN .zshrc already exits. Moving it to $dest..."
  mv .zshrc $dest || exit 1
  echo -e "$OK"
else
  echo -e "$NF"
fi
echo -en "$INFO Downloading .zshrc from grml website..."
curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1
echo -e "$OK"

## Download .zshrc.local.
echo -en "$INFO Checking for .zshrc.local..."
if [[ -f ".zshrc.local" ]]; then
  dest=".zshrc.local.$(date +%F).old"
  echo -en "\n$WARN .zshrc.local already exits. Moving it to $dest..."
  mv ".zshrc.local" $dest || exit 1
  echo -e "$OK"
else
  echo -e "$NF"
fi
echo -en "$INFO Downloading .zshrc.local from GitHub..."
curl -sLo ".zshrc.local" "https://raw.githubusercontent.com/scotow/zsh-setup/master/local.zsh" || exit 1
echo -e "$OK"

## Check/create .zsh directory.
echo -en "$INFO Checking for .zsh directory..."
if [[ -e .zsh ]]; then
  if [[ -d .zsh ]]; then
    echo -e "$OK"
  else
    echo -e "\n$ERROR .zsh already exists and it's not a directory. Exiting."
    exit 1
  fi  
else
  echo -e "$NF"
  echo -en "$INFO Creating .zsh directory..."
  mkdir .zsh || exit 1
  echo -e "$OK"
fi

## Download zsh-autosuggestions and zsh-syntax-highlighting.
for plugin in 'zsh-autosuggestions' 'zsh-syntax-highlighting'; do
  echo -en "$INFO Checking for $plugin..."
  if [[ -d ".zsh/$plugin" ]]; then
    echo -e "\n$WARN .zsh/$plugin already exits. Skipping."
  else
    echo -e "$NF"
    echo -en "$INFO Cloning $plugin from GitHub..."
    git clone -q "https://github.com/zsh-users/$plugin" ".zsh/$plugin" || exit 1
    echo -e "$OK"
  fi
done

## Install fzf binary.
echo -en "$INFO Checking for fzf binnary..."
if ! type fzf >/dev/null 2>&1; then
  echo -e "$NF"
  if [[ -e .zsh/bin/fzf ]]; then
    echo -e "$WARN .zsh/bin/fzf already exists but is not in the the current path."
  else
    echo -en "$INFO Installing fzf is only supported on linux/macOS amd64. Checking..."
    distro="$(uname -s | tr 'A-Z' 'a-z')"
    if [[ $distro == *linux* ]]; then
      distro="linux"
      echo -e "$OK"
    elif [[ $distro == *darwin* ]]; then
      distro="darwin"
      echo -e "$OK"
    else
      echo -e "$WARN Cannot use the following distro for fzf installation: $distro. Skipping fzf installation."
      distro="none"
    fi

    echo -en "$INFO Checking for .zsh/bin directory..."
    if [[ -e .zsh/bin ]]; then
      if [[ -d .zsh/bin ]]; then
        echo -e "$OK"
      else
        echo -e "\n$WARN .zsh/bin already exists and it's not a directory. Skipping fzf installation."
        distro="none"
      fi  
    else
      echo -e "$NF"
      echo -en "$INFO Creating .zsh/bin directory..."
      mkdir .zsh/bin || exit 1
      echo -e "$OK"
    fi

    if [[ "$distro" != "none" ]]; then
      echo -en "$INFO Fetching fzf last version number..."
      version=$(curl -sI 'https://github.com/junegunn/fzf-bin/releases/latest' | grep Location: | rev | cut -d/ -f1 | rev | tr -d '\n\r')

      if [[ -z "$version" ]]; then
        echo -e "\n$ERROR Cannot fetch latest version number. Exiting."
        exit 1
      fi
      
      echo -e "${BLUE}$version${NC}"
      echo -en "$INFO Downloading fzf binnary..."
      curl -sL "https://github.com/junegunn/fzf-bin/releases/download/$version/fzf-$version-${distro}_amd64.tgz" | tar -xzf - -C .zsh/bin || exit 1
      echo -e "$OK"
    fi
  fi
else
  echo -e "$OK"
fi

## Download fzf plugins.
for file in fzf-key-bindings fzf-completion; do
  echo -en "$INFO Checking for $file..."
  if [[ -f ".zsh/$file.zsh" ]]; then
    dest=".zsh/$file.zsh.$(date +%F).old"
    echo -e "\n[WARN] .zsh/$file.zsh already exits. Moving it to $dest."
    mv ".zsh/$file.zsh" $dest || exit 1
    echo -e "$OK"
  else
    echo -e "$NF"
  fi
  echo -en "$INFO Downloading $file from Github..."
  curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
  echo -e "$OK"
done

echo -e "\n$INFO Installation complete. Restart your shell or run \"exec zsh\" to apply."
