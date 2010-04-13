# vim: set syntax=zsh
autoload -U compinit
compinit
autoload colors
setopt auto_pushd
setopt auto_cd
setopt correct
setopt cdable_vars

# zshスクリプト読み込み
source ~/.zsh/cdd/cdd

##プロンプト行 http://www.jmuk.org/diary/2007/02/23/2
PROMPTTTY=`tty | sed -e 's/^\/dev\///'`
PROMPT="[%B${cyan}%~${default}%b] <%B${PROMPTTTY}%b> %E
%b%# "
if [ `whoami` = root ]; then
        RPROMPT="${red}%B%n${default}%b@${logreen}%m${default}%b"
else
        RPROMPT="${loyellow}%n${default}%b@${logreen}%m${default}%b"
fi
SPROMPT="${red}Correct ${default}> '%r' [%BY%bes %BN%bo %BA%bbort %BE%bdit] ? "


## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# aliases
alias v=vim
alias svnst="svn st --ignore-externals -q"
alias symfony="symfony --color"

export EDITOR=vim

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

#japanese setting (tenkoma)
LANG="ja_JP.UTF-8"
LC_ALL="${LANG}"
export LANG
export LC_ALL

#http://journal.mycom.co.jp/column/zsh/003/index.html
HISTFILE=~/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

export JAVA_HOME=/usr/lib/j2sdk1.5-sun
export CC=/usr/bin/gcc

#シェルの操作をviライクに
bindkey -v

#履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# http://nijino.homelinux.net/diary/200206.shtml
if [ "$TERM" = "screen" ]; then
    chpwd () {
        echo -n "_`dirs`\\"
        _reg_pwd_screennum
    }
    preexec() {
        # see [zsh-workers:13180]
        # http://www.zsh.org/mla/workers/2000/msg03993.html
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg)
            if (( $#cmd == 1 )); then
                cmd=(builtin jobs -l %+)
            else
                cmd=(builtin jobs -l $cmd[2])
            fi
            ;;
            %*) 
            cmd=(builtin jobs -l $cmd[1])
            ;;
            cd)
            if (( $#cmd == 2)); then
                cmd[1]=$cmd[2]
            fi
            ;&
            *)
            echo -n "k$cmd[1]:t\\"
            return
            ;;
        esac

        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
        cmd=(${(z)${(e):-\$jt$num}})
        echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

# ログインしたらすぐにscreen起動
[ ${STY} ] || screen -rx || screen -D -RR
