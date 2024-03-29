# Filename:      /etc/skel/.zshrc
# Purpose:       config file for zsh (z shell)
# Authors:       (c) grml-team (grml.org)
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2 or any later version.
################################################################################
# Nowadays, grml's zsh setup lives in only *one* zshrc file.
# That is the global one: /etc/zsh/zshrc (from grml-etc-core).
# It is best to leave *this* file untouched and do personal changes to
# your zsh setup via ${HOME}/.zshrc.local which is loaded at the end of
# the global zshrc.
#
# That way, we enable people on other operating systems to use our
# setup, too, just by copying our global zshrc to their ${HOME}/.zshrc.
# Adjustments would still go to the .zshrc.local file.
################################################################################

## Inform users about upgrade path for grml's old zshrc layout, assuming that:
## /etc/skel/.zshrc was installed as ~/.zshrc,
## /etc/zsh/zshrc was installed as ~/.zshrc.global and
## ~/.zshrc.local does not exist yet.
if [ -r ~/.zshrc -a -r ~/.zshrc.global -a ! -r ~/.zshrc.local ] ; then
    printf '-!-\n'
    printf '-!- Looks like you are using the old zshrc layout of grml.\n'
    printf '-!- Please read the notes in the grml-zsh-refcard, being'
    printf '-!- available at: http://grml.org/zsh/\n'
    printf '-!-\n'
    printf '-!- If you just want to get rid of this warning message execute:\n'
    printf '-!-        touch ~/.zshrc.local\n'
    printf '-!-\n'
fi

## Settings for umask
#if (( EUID == 0 )); then
#    umask 002
#else
#    umask 022
#fi

## Now, we'll give a few examples of what you might want to use in your
## .zshrc.local file (just copy'n'paste and uncomment it there):

## Prompt theme extension ##

# Virtualenv support

#function virtual_env_prompt () {
#    REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
#}
#grml_theme_add_token  virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
#zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host path vcs percent

## ZLE tweaks ##

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
#bindkey -M menuselect 'h' vi-backward-char        # left
#bindkey -M menuselect 'k' vi-up-line-or-history   # up
#bindkey -M menuselect 'l' vi-forward-char         # right
#bindkey -M menuselect 'j' vi-down-line-or-history # bottom

## set command prediction from history, see 'man 1 zshcontrib'
#is4 && zrcautoload predict-on && \
#zle -N predict-on         && \
#zle -N predict-off        && \
#bindkey "^X^Z" predict-on && \
#bindkey "^Z" predict-off

## press ctrl-q to quote line:
#mquote () {
#      zle beginning-of-line
#      zle forward-word
#      # RBUFFER="'$RBUFFER'"
#      RBUFFER=${(q)RBUFFER}
#      zle end-of-line
#}
#zle -N mquote && bindkey '^q' mquote

## define word separators (for stuff like backward-word, forward-word, backward-kill-word,..)
#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' # the default
#WORDCHARS=.
#WORDCHARS='*?_[]~=&;!#$%^(){}'
#WORDCHARS='${WORDCHARS:s@/@}'

# just type '...' to get '../..'
#rationalise-dot() {
#local MATCH
#if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
#  LBUFFER+=/
#  zle self-insert
#  zle self-insert
#else
#  zle self-insert
#fi
#}
#zle -N rationalise-dot
#bindkey . rationalise-dot
## without this, typing a . aborts incremental history search
#bindkey -M isearch . self-insert

#bindkey '\eq' push-line-or-edit

## some popular options ##

## add `|' to output redirections in the history
#setopt histallowclobber

## try to avoid the 'zsh: no matches found...'
#setopt nonomatch

## warning if file exists ('cat /dev/null > ~/.zshrc')
#setopt NO_clobber

## don't warn me about bg processes when exiting
#setopt nocheckjobs

## alert me if something failed
#setopt printexitvalue

## with spelling correction, assume dvorak kb
#setopt dvorak

## Allow comments even in interactive shells
#setopt interactivecomments


## compsys related snippets ##

## changed completer settings
#zstyle ':completion:*' completer _complete _correct _approximate
#zstyle ':completion:*' expand prefix suffix

## another different completer setting: expand shell aliases
#zstyle ':completion:*' completer _expand_alias _complete _approximate

## to have more convenient account completion, specify your logins:
#my_accounts=(
# {grml,grml1}@foo.invalid
# grml-devel@bar.invalid
#)
#other_accounts=(
# {fred,root}@foo.invalid
# vera@bar.invalid
#)
#zstyle ':completion:*:my-accounts' users-hosts $my_accounts
#zstyle ':completion:*:other-accounts' users-hosts $other_accounts

## add grml.org to your list of hosts
#hosts+=(grml.org)
#zstyle ':completion:*:hosts' hosts $hosts

## telnet on non-default ports? ...well:
## specify specific port/service settings:
#telnet_users_hosts_ports=(
#  user1@host1:
#  user2@host2:
#  @mail-server:{smtp,pop3}
#  @news-server:nntp
#  @proxy-server:8000
#)
#zstyle ':completion:*:*:telnet:*' users-hosts-ports $telnet_users_hosts_ports

## the default grml setup provides '..' as a completion. it does not provide
## '.' though. If you want that too, use the following line:
#zstyle ':completion:*' special-dirs true

## aliases ##

## translate
#alias u='translate -i'

## ignore ~/.ssh/known_hosts entries
#alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=keyboard-interactive"'


## global aliases (for those who like them) ##

alias -g '...'='../..'
alias -g '....'='../../..'
alias -g BG='& exit'
alias -g C='|wc -l'
alias -g G='|grep'
alias -g H='|head'
#alias -g Hl=' --help |& less -r'
#alias -g K='|keep'
alias -g L='|less'
#alias -g LL='|& less -r'
#alias -g M='|most'
alias -g N='&>/dev/null'
#alias -g R='| tr A-z N-za-m'
#alias -g SL='| sort | less'
#alias -g S='| sort'
alias -g T='|tail'
alias -g V='| vim -'

## instead of global aliase it might be better to use grmls $abk assoc array, whose contents are expanded after pressing ,.
#$abk[SnL]="| sort -n | less"

## get top 10 shell commands:
#alias top10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

## Execute \kbd{./configure}
#alias CO="./configure"

## Execute \kbd{./configure --help}
#alias CH="./configure --help"

## miscellaneous code ##

## Use a default width of 80 for manpages for more convenient reading
#export MANWIDTH=${MANWIDTH:-80}

## Set a search path for the cd builtin
#cdpath=(.. ~)

## variation of our manzsh() function; pick you poison:
#manzsh()  { /usr/bin/man zshall |  most +/"$1" ; }

## Switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
#bash() {
#    NO_SWITCH="yes" command bash "$@"
#}
#restart () {
#    exec $SHELL $SHELL_ARGS "$@"
#}

## Handy functions for use with the (e::) globbing qualifier (like nt)
#contains() { grep -q "$*" $REPLY }
#sameas() { diff -q "$*" $REPLY &>/dev/null }
#ot () { [[ $REPLY -ot ${~1} ]] }

## get_ic() - queries imap servers for capabilities; real simple. no imaps
#ic_get() {
#    emulate -L zsh
#    local port
#    if [[ ! -z $1 ]] ; then
#        port=${2:-143}
#        print "querying imap server on $1:${port}...\n";
#        print "a1 capability\na2 logout\n" | nc $1 ${port}
#    else
#        print "usage:\n  $0 <imap-server> [port]"
#    fi
#}

## List all occurrences of programm in current PATH
#plap() {
#    emulate -L zsh
#    if [[ $# = 0 ]] ; then
#        echo "Usage:    $0 program"
#        echo "Example:  $0 zsh"
#        echo "Lists all occurrences of program in the current PATH."
#    else
#        ls -l ${^path}/*$1*(*N)
#    fi
#}

## Find out which libs define a symbol
#lcheck() {
#    if [[ -n "$1" ]] ; then
#        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
#    else
#        echo "Usage: lcheck <function>" >&2
#    fi
#}

## Download a file and display it locally
#uopen() {
#    emulate -L zsh
#    if ! [[ -n "$1" ]] ; then
#        print "Usage: uopen \$URL/\$file">&2
#        return 1
#    else
#        FILE=$1
#        MIME=$(curl --head $FILE | \
#               grep Content-Type | \
#               cut -d ' ' -f 2 | \
#               cut -d\; -f 1)
#        MIME=${MIME%$'\r'}
#        curl $FILE | see ${MIME}:-
#    fi
#}

## Memory overview
#memusage() {
#    ps aux | awk '{if (NR > 1) print $5;
#                   if (NR > 2) print "+"}
#                   END { print "p" }' | dc
#}

## print hex value of a number
#hex() {
#    emulate -L zsh
#    if [[ -n "$1" ]]; then
#        printf "%x\n" $1
#    else
#        print 'Usage: hex <number-to-convert>'
#        return 1
#    fi
#}

## log out? set timeout in seconds...
## ...and do not log out in some specific terminals:
#if [[ "${TERM}" == ([Exa]term*|rxvt|dtterm|screen*) ]] ; then
#    unset TMOUT
#else
#    TMOUT=1800
#fi

## associate types and extensions (be aware with perl scripts and anwanted behaviour!)
#check_com zsh-mime-setup || { autoload zsh-mime-setup && zsh-mime-setup }
#alias -s pl='perl -S'

## ctrl-s will no longer freeze the terminal.
stty erase "^?"

## you want to automatically use a bigger font on big terminals?
#if [[ "$TERM" == "xterm" ]] && [[ "$LINES" -ge 50 ]] && [[ "$COLUMNS" -ge 100 ]] && [[ -z "$SSH_CONNECTION" ]] ; then
#    large
#fi

## Some quick Perl-hacks aka /useful/ oneliner
#bew() { perl -le 'print unpack "B*","'$1'"' }
#web() { perl -le 'print pack "B*","'$1'"' }
#hew() { perl -le 'print unpack "H*","'$1'"' }
#weh() { perl -le 'print pack "H*","'$1'"' }
#pversion()    { perl -M$1 -le "print $1->VERSION" } # i. e."pversion LWP -> 5.79"
#getlinks ()   { perl -ne 'while ( m/"((www|ftp|http):\/\/.*?)"/gc ) { print $1, "\n"; }' $* }
#gethrefs ()   { perl -ne 'while ( m/href="([^"]*)"/gc ) { print $1, "\n"; }' $* }
#getanames ()  { perl -ne 'while ( m/a name="([^"]*)"/gc ) { print $1, "\n"; }' $* }
#getforms ()   { perl -ne 'while ( m:(\</?(input|form|select|option).*?\>):gic ) { print $1, "\n"; }' $* }
#getstrings () { perl -ne 'while ( m/"(.*?)"/gc ) { print $1, "\n"; }' $*}
#getanchors () { perl -ne 'while ( m/�([^��\n]+)�/gc ) { print $1, "\n"; }' $* }
#showINC ()    { perl -e 'for (@INC) { printf "%d %s\n", $i++, $_ }' }
#vimpm ()      { vim `perldoc -l $1 | sed -e 's/pod$/pm/'` }
#vimhelp ()    { vim -c "help $1" -c on -c "au! VimEnter *" }

## END OF FILE #################################################################

zstyle ':completion:*' insert-tab false

if [[ "$(tty)" == *"tty"* && "$(uname -s)" != "Darwin" ]]; then
    print -z startx
fi

## Paths
if [[ -d ~/bin ]]; then
    export PATH=$PATH:$HOME/bin
fi

if [[ -d ~/.zsh/bin ]]; then
    export PATH=$PATH:$HOME/.zsh/bin
fi

if [[ -d ~/.cargo/bin ]]; then
    export PATH=$PATH:$HOME/.cargo/bin
fi

if [[ -d ~/.homebrew/bin ]]; then
    export PATH=$PATH:$HOME/.homebrew/bin
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi

## Go
if type go >/dev/null 2>&1; then
    if [[ -z "$GOPATH" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
            export GOPATH="$HOME/Documents/Coding/go"
        elif [[ "$(uname -s)" == "Linux" ]]; then
            export GOPATH="$HOME/go"
        fi
    fi
    alias cdgo='cd $GOPATH/src/github.com/$USER'
fi

## Hub
if type hub >/dev/null 2>&1; then
    eval "$(hub alias -s)"
fi

## Personal MacOS alias. Should be remove if you are not me.
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ -d "$HOME/Documents/Coding/Script" ]]; then
        export PATH="$PATH:$HOME/Documents/Coding/Script"
    fi
    if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi
    local RUSTROVER_LIST=(/Applications/RustRover*.app/Contents/MacOS)
    if [[ ${#RUSTROVER_LIST[@]} -ge 1 ]]; then
        export PATH="$PATH:${RUSTROVER_LIST[1]}"
    fi
fi

## Less
if type less >/dev/null 2>&1; then
    export LESS=" -R "
    alias less='less -m -N -g -i -J -u -Q --mouse'
  
    if type src-hilite-lesspipe.sh >/dev/null 2>&1; then
        export LESSOPEN="| src-hilite-lesspipe.sh %s"
    fi
fi

## Suggestions & Highlighting
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^[[Z' autosuggest-accept
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^[[Z' autosuggest-accept
elif [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^[[Z' autosuggest-accept
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

## Fzf
if type fzf >/dev/null 2>&1; then
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
        source /usr/local/opt/fzf/shell/key-bindings.zsh
    elif [[ -f ~/.zsh/fzf-key-bindings.zsh ]]; then 
        source ~/.zsh/fzf-key-bindings.zsh
    fi

    if [[ -f /usr/share/fzf/completion.zsh ]]; then
        source /usr/share/fzf/completion.zsh
    elif [[ -f /usr/local/opt/fzf/shell/completion.zsh ]]; then
        source /usr/local/opt/fzf/shell/completion.zsh
    elif [[ -f ~/.zsh/fzf-completion.zsh ]]; then 
        source ~/.zsh/fzf-completion.zsh
    fi

    if type pacman xargs sudo >/dev/null 2>&1; then
        alias pacman-search='pacman -Slq | fzf -m --preview  "pacman -Si {1}" | xargs -ro sudo pacman -S'
    fi

    if type yay xargs >/dev/null 2>&1; then
        alias yay-search='yay -Slq | fzf -m --preview "yay -Si {1}"| xargs -ro yay -S'
    fi
fi

## Navi
if type navi >/dev/null 2>&1; then
    source "$(navi widget zsh)"
fi

## Z
if type zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
elif [[ -f "/usr/share/z/z.sh" ]]; then
    source /usr/share/z/z.sh
fi

## Jump
if type jump >/dev/null 2>&1; then
    eval "$(jump shell)"
fi

## Syntax highlighting
if type highlight &>/dev/null && ! type ccat &>/dev/null; then
    alias ccat='highlight -O xterm256'
fi

## Helpers
alias christmas-tree='curl -s https://raw.githubusercontent.com/sergiolepore/ChristBASHTree/e757367e54e4d95166d9037b31211ad087e246fe/tree-EN.sh | bash'

sha256sum() {
    local REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if [[ $1 =~ $REGEX ]]; then
        curl -sL $1 | command sha256sum
    else
        command sha256sum $@
    fi
}

flatten-mega() {
    local DIRS="$@"

    if [[ -z "$DIRS" ]]; then
	    DIRS='.'
    fi

    for d in "$DIRS"; do
	    find "$d" -type d -name "Featurettes*" -name "EXTRAS*" -exec rm -r {} +
	    find "$d" -mindepth 2 -type f -exec mv -t "$d" -n '{}' +
	    find "$d" -type d -empty -delete
    done
}

qrcode() {
    local ENC='UTF8'

    if [[ "$TERM" == "xterm-256color" ]]; then
      ENC='ANSI256'
    fi
    qrencode -t $ENC "$@"
}

qlobe() {
    local CODE=$(curl -s https://raw.githubusercontent.com/knoxknox/qlobe/86400d84fb4d7d4aae02d02f983f0eed6736d2ba/src/qlobe.rb)
    clear; for ((;;)); do for i in {0..71}; do tput cup 0 0; echo $CODE | ruby - $((i * 5)); sleep 0.1; done; done;
}

qrcp() {
    local ARGS="$@"

    if [[ $# -eq 0 ]]; then
        ARGS="receive"
    fi
    command qrcp $ARGS | gawk 'match($0, /http:\/\/(.+):[0-9]+\/(.+\/.+)/, g) { r=sprintf("https://%s/%s", g[1], g[2]); print r; system("qrencode -t UTF8 " r) }'
}

# vim:set ts=4 sts=4 sw=4 et:
