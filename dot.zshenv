PATH=$PATH:~/local/bin

case "$OSTYPE" in
# Mac OS X
darwin*)
    # PATH
    # MacPorts
    PATH=/opt/local/bin:/opt/local/sbin/opt/local/apache2/bin:~/bin:$PATH
    MANPATH=/opt/local/man:$MANPATH
    # flex SDK
    PATH=$PATH:/Developer/SDKs/flex_sdk_3/bin/
    # local bin
    PATH=$PATH:/usr/local/bin
    # cakephp console
    PATH=$PATH:~/local/lib/cakephp1.3/cake/console
    # lithium console
    PATH=$PATH:~/NetBeansProjects/lithium-0.9.5/libraries/lithium/console
    # android sdk
    PATH=$PATH:/Applications/android_sdk/r08/tools
    # xcode
    PATH=$PATH:/Developer/usr/bin
    # rbenv
    PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
    # jenkins
    JENKINS_HOME=$HOME/.jenkins

    export CC=gcc-4.2

    export DISPLAY=:0.0

    export HGENCODING=utf-8

    alias ls="ls -G -w"
    alias ll="ls -lhaGv"
    alias la="ls -aGv"
    alias vless="/opt/local/share/vim/vim73/macros/less.sh"
    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
    alias v='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'

    # jsTestDriver
    export JSTESTDRIVER_HOME=~/local/bin
;;
linux*)
    alias ls="ls --color=auto"
    alias ll="ls -la --color=auto"
    alias la="ls -a --color=auto"
    alias vless="/usr/share/vim/vim71/macros/less.sh"
;;
esac

export PATH
export MANPATH

