case "$OSTYPE" in
# Mac OS X
darwin*)
    # PATH
    # MacPorts
    export PATH=/opt/local/bin:/opt/local/sbin/opt/local/apache2/bin:~/bin:$PATH
    export MANPATH=/opt/local/man:$MANPATH
    # flex SDK
    export PATH=$PATH:/Developer/SDKs/flex_sdk_3/bin/
    # local bin
    export PATH=$PATH:~/local/bin:/usr/local/bin
    # cakephp console
    export PATH=$PATH:~/local/lib/cakephp1.2/cake/console/

    export DISPLAY=:0.0

    export HGENCODING=utf-8

    alias ls="ls -G -w"
    alias ll="ls -lhaGv"
    alias la="ls -aGv"
    alias less="/opt/local/share/vim/vim72/macros/less.sh"
;;
linux*)
    alias ls="ls --color=auto"
    alias ll="ls -la --color=auto"
    alias la="ls -a --color=auto"
    alias less="/usr/share/vim/vim71/macros/less.sh"
;;
esac

