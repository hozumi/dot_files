export GOROOT=$HOME/go
export GOARCH=amd64
export GOOS=darwin
export CLOJURE_EXT=~/.clojure
export EC2_HOME=/Users/fatrow/aws/ec2-api-tools
export EC2_PRIVATE_KEY=/Users/fatrow/aws/pk-C3FZXKTC7O5YZMQXNN5D6HF7FKE33BBL.pem
export EC2_CERT=/Users/fatrow/aws/cert-C3FZXKTC7O5YZMQXNN5D6HF7FKE33BBL.pem
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home
export PATH=$PATH:$JAVA_HOME/bin:$EC2_HOME/bin:~/bin:/opt/local/bin:~/code/appengine-java-sdk-1.3.3.1/bin:/Users/fatrow/app/apache-cassandra-0.6.3/bin
export CLASSPATH=$CLASSPASS:/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Classes:~/.clojure/clojure.jar
autoload -U compinit; compinit
alias clj=clj-env-dir

#2010/9/21 OpenCL
export ATISTREAMSDKROOT=~/app/ati-stream-sdk-v2.2-lnx64
export ATISTREAMSDKSAMPLESROOT=$ATISTREAMSDKROOT/samples
export LD_LIBRARY_PATH=$ATISTREAMSDKROOT/lib/x86_64:$LD_LIBRARY_PATH

#2010/10/17 kumofs
export LD_LIBRARY_PATH=/usr/local/lib:/opt/local/lib:$LD_LIBRARY_PATH

#2010/10/22 emacs
alias emacs='emacs -nw'

#2010/10/22 zsh prompt
export PROMPT="[%?]%T %m %1d%% "

#2010/11/4 git PATH
export PATH=/usr/local/git/bin:$PATH

#2010/12/2 depot_tools
export PATH=~/app/depot_tools:$PATH

#2011/3/8 show git branch
# http://stackoverflow.com/questions/1128496/to-get-a-prompt-which-indicates-git-branch-in-zsh
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

#export PATH=$GEM_HOME/bin:$PATH

#2011/4/13 android
export ANDROID_SDK=~/app/android-sdk-mac_x86

#2011/10/18 for Octave and gnuplot
export PATH=/Applications/gnuplot.app:/Applications/gnuplot.app/bin:$PATH
export GNUTERM=x11

#2011/11/15 for ClojureScript
# https://github.com/clojure/clojurescript/wiki/Quick-Start
export CLOJURESCRIPT_HOME=~/code/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# 2011/12/11 履歴を残す
# http://0xcc.net/unimag/3/
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する
setopt share_history
# lsとかで一覧表示された補完候補 を C-n C-p C-f C-b のカーソルで選択
zstyle ':completion:*:default' menu select=1
# コマンド特有の補完
autoload -U compinit
compinit

#2013/1/25 for npm bin
export PATH=/usr/local/share/npm/bin:$PATH

#2013/2/23 rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
source ~/.rbenv/completions/rbenv.zsh
