# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="intheloop"
ZSH_THEME="pygmalion"
#ZSH_THEME="avit"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git autojump sudo colored-man colorize cp history debian emoji-clock emacs adb ant)

source $ZSH/oh-my-zsh.sh
#set -o vi
set -o emacs

eval `dircolors ~/soft_make/dircolors-solarized-master/dircolors.ansi-universal`

# Customize to your needs...
export PATH=$PATH:/home/jiazhang/bin:/usr/local/bin:/usr/bin:/bin:/usr/games:/home/jiazhang/bin/:/usr/local/android_tools/android-sdk-linux_x86/platform-tools:/usr/local/android_tools/android-sdk-linux_x86/tools:/opt/bbndk/host_10_1_0_132/linux/x86/usr/bin:/home/jiazhang/bb/blackberry.tools.SDK/bin:/home/jiazhang/tools/tools/pngshrink:/opt/wireshark-1.8.13/bin:/home/jiazhang/pkg/depot_tools:/home/jiazhang/pkg/go/bin

export JAVA_HOME=/opt/java/jdk1.8.0_20
export ANDROID_HOME=/opt/android_tools/android-sdk-linux_x86

export CCACHE_DIR=/mnt/temp/CCACHE
export ANDROID_SDK_DIR=/usr/local/android_tools/android-sdk-linux_x86
export ANDROID_NDK_DIR=/usr/local/android_tools/android-ndk-r10d
export ANDROID_NDK=/usr/local/android_tools/android-ndk-r10d

export ANDROID_TOOLCHAIN=/opt/android_tools/android-ndk-r10d/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin

export CCACHE_COMPILERCHECK=content
export COMPONENT_BUILD=NO
export ICECC=YES ICECC_PREFIX=$HOME/pkg/icecc

export FPATH=~/zshfuncs:$FPATH

export CLUSTER=zj

#bindkey -v
bindkey "\eA" history-search-backward
bindkey "\eB" history-search-forward

#alias gk="gitk -500&"
#alias mini="cd ~/workspace/oupeng"
alias adbt="adb shell /data/data/tcpdump -p -vv -s 0 -i any -w /sdcard/capture.pcap"
alias adbb="adb shell am start -a android.intent.action.VIEW -d"
alias open="gnome-open ."

alias fndd="git fetch origin nhorizon_dev_dogwood:nhorizon_dev_dogwood"
alias gri="git rebase -i"

alias a="adb"
alias al="adb logcat -v time"
alias alc="adb logcat -c"
alias alg="adb logcat -v time | grep"
alias alsg="noglob adbloggrep"
adbloggrep() {
    adb logcat -v time -s $@
}
alias aleg="adb logcat -v time | egrep "

alias tsharkspdy="tshark -d tcp.port==443,spdy -R spdy "

alias m="minibuild"
alias cm="ant clean; minibuild"
alias ui="minibuild i"
alias uo="adb uninstall com.oupeng.mini.android"
alias i="noglob installFunc"
installFunc() {
    if [[ $# -eq 0 ]]; then
        minibuild -i
    else
        adb install $@
    fi
}

vimFile () {
    echo $@ | awk -F\: '{print $1}'
}
vimLine () {
    echo $@ | awk -F\: '{print $2}'
}
alias vi="noglob viml"
alias gvi="noglob gviml"
viml () {
    vim $(vimFile $@) $([[ -z $(vimLine $@) ]] && echo "" || echo "+")$(vimLine $@)
}
gviml () {
    gvim --remote-send ":e $(vimFile $@)<CR> :$(vimLine $@)<CR>"
}

alias gk="noglob gitkbr"
gitkbr () {
    gitk -1000 $@ &
}

alias f="noglob findit"
findit () {
    local res=~/.findr
    find . -name $* | tee $res
    local lines=`cat $res | wc -l`
    if [ $lines -eq 1 ];then
        read -k 1 cmd
        case $cmd in
            "q")
                return
                ;;
            "e")
                vi `cat $res`
                ;;
            "d")
                rm `cat $res`
                ;;
        esac
    fi
}

alias gg="noglob gitgrep"
gitgrep () {
    git grep -n $*
}

alias gj="noglob grepjava"
grepjava () {
    grep -rn $* * --include='*.java'
}

alias psg="noglob psauxgrep"
psauxgrep () {
    ps aux | grep $*
}

alias b="noglob wamBuild"
alias cb="noglob wamBuild -cmuid7q"
alias c5b="noglob wamBuild -cmuid5q"
wamBuild () {
    if [ $# -eq 0 ];then
        ~/bin/wamBuild -muid7q
    else
        ~/bin/wamBuild $*
    fi
}

alias mg="noglob gitFunc"
gitFunc () {
    local files=$(git status -s)
    echo $files
    echo -n ": "
    read cmd
    case $cmd in
        "?")
            echo "e <file>:vi file"
            echo "l <file>:less file"
            echo "a <file>:git add file"
            echo "q :exit"
            ;;
        "l")
            #less $(echo $files | se)
            ;;
    esac
}

alias gadd="noglob gitadd"
gitadd () {
    git status -s | awk '{print $2}' | xargs git add
}

#alias gpc="noglob gitpushcritic"
#gitpushcritic () {
#    local branch=$(cat $(git rev-parse --git-dir)/HEAD))
#    branch=${branch#ref: refs/heads/}
#    git push $1 critic :r/jiazhang/${branch}
#}

alias em="noglob emacs_cmd"
emacs_cmd () {
    emacs $@ 2> /dev/null &
}

alias ec="noglob emacsclient_gui"
emacsclient_gui () {
    emacsclient -c $@ &
}
