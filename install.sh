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
  echo -e '\n[WARN] zsh not installed.'
fi

## Moving to home directory for installation.
echo -n '[INFO] Moving to home directory...'
cd $HOME || exit 1
echo 'OK'

## Download grml .zshrc.
echo -n '[INFO] Checking for .zshrc...'
if [[ -f .zshrc ]]; then
  dest=".zshrc.$(date +%F).old"
  echo -en "\n[WARN] .zshrc already exits. Moving it to $dest..."
  mv .zshrc $dest || exit 1
  echo 'OK'
else
  echo 'Not found'
fi
echo -n '[INFO] Downloading .zshrc from grml website...'
curl -sLo .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc || exit 1
echo 'OK'

## Download .zshrc.local.
echo -n '[INFO] Checking for .zshrc.local...'
if [[ -f ".zshrc.local" ]]; then
  dest=".zshrc.local.$(date +%F).old"
  echo -en "\n[WARN] .zshrc.local already exits. Moving it to $dest..."
  mv ".zshrc.local" $dest || exit 1
  echo 'OK'
else
  echo 'Not found'
fi
echo -n '[INFO] Downloading .zshrc.local from GitHub...'
curl -sLo ".zshrc.local" "https://raw.githubusercontent.com/scotow/zsh-setup/master/local.zsh" || exit 1
echo 'OK'

## Check/create .zsh directory.
echo -n '[INFO] Checking for .zsh directory...'
if [[ -e .zsh ]]; then
  if [[ -d .zsh ]]; then
    echo 'OK'
  else
    echo -e "\n[ERROR] .zsh already exists and it's not a directory. Exiting."
    exit 1
  fi  
else
  echo 'Not found'
  echo -n '[INFO] Creating .zsh directory...'
  mkdir .zsh || exit 1
  echo 'OK'
fi

## Download zsh-autosuggestions and zsh-syntax-highlighting.
for plugin in 'zsh-autosuggestions' 'zsh-syntax-highlighting'; do
  echo -n "[INFO] Checking for $plugin..."
  if [[ -d ".zsh/$plugin" ]]; then
    echo -e "\n[WARN] .zsh/$plugin already exits. Skipping."
  else
    echo 'Not found'
    echo -n "[INFO] Cloning $plugin from GitHub..."
    git clone -q "https://github.com/zsh-users/$plugin" ".zsh/$plugin" || exit 1
    echo 'OK'
  fi
done

## Install fzf binary.
echo -n '[INFO] Checking for fzf binnary...'
if ! type fzf >/dev/null 2>&1; then
  echo 'Not found'
  if [[ -e .zsh/bin/fzf ]]; then
    echo '[WARN] .zsh/bin/fzf already exists but is not in the the current path.'
  else
    echo -n '[INFO] Installing fzf is only supported on linux/macOS amd64. Checking...'
    distro="$(uname -s | tr 'A-Z' 'a-z')"
    if [[ $distro == *linux* ]]; then
      distro="linux"
      echo 'OK'
    elif [[ $distro == *darwin* ]]; then
      distro="darwin"
      echo 'OK'
    else
      echo "[WARN] Cannot use the following distro for fzf installation: $distro. Skipping fzf installation."
      distro="none"
    fi

    echo -n '[INFO] Checking for .zsh/bin directory...'
    if [[ -e .zsh/bin ]]; then
      if [[ -d .zsh/bin ]]; then
        echo 'OK'
      else
        echo -e "\n[WARN] .zsh/bin already exists and it's not a directory. Skipping fzf installation."
        distro="none"
      fi  
    else
      echo 'Not found'
      echo -n '[INFO] Creating .zsh/bin directory...'
      mkdir .zsh/bin || exit 1
      echo 'OK'
    fi

    if [[ "$distro" != "none" ]]; then
      echo -n '[INFO] Fetching fzf last version number...'
      version=$(curl -sI 'https://github.com/junegunn/fzf-bin/releases/latest' | grep Location: | rev | cut -d/ -f1 | rev | tr -d '\n\r')

      if [[ -z "$version" ]]; then
        echo -e '\n[ERROR] Cannot fetch latest version number. Exiting.'
        exit 1
      fi
      
      echo $version
      echo -n '[INFO] Downloading fzf binnary...'
      curl -sL "https://github.com/junegunn/fzf-bin/releases/download/$version/fzf-$version-${distro}_amd64.tgz" | tar -xzf - -C .zsh/bin || exit 1
      echo 'OK'
    fi
  fi
else
  echo 'OK'
fi

## Download fzf plugins.
for file in fzf-key-bindings fzf-key-completion; do
  echo -n "[INFO] Checking for $file..."
  if [[ -f ".zsh/$file.zsh" ]]; then
    dest=".zsh/$file.zsh.$(date +%F).old"
    echo -e "\n[WARN] .zsh/$file.zsh already exits. Moving it to $dest."
    mv ".zsh/$file.zsh" $dest || exit 1
    echo 'OK'
  else
    echo 'Not found'
  fi
  echo -n "[INFO] Downloading $file from Github..."
  curl -sLo ".zsh/$file.zsh" "https://raw.githubusercontent.com/scotow/zsh-setup/master/$file.zsh" || exit 1
  echo 'OK'
done

echo -e '\n[INFO] Installation complete. Restart your shell or run "exec zsh" to apply.'