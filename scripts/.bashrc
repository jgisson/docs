# Env
HISTSIZE=5000
# Env override PATH (useful on Windows)
#PATH='/d/tools/vscode/bin':$PATH

# Alias standard
alias ll='ls -l'
alias la='ls -al'
alias find-process='netstat -aon | grep'

# Docker alias
alias dockps='docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Names}}"'
alias dockimg='docker image inspect --format "{{.ID}} {{.RepoTags}} {{.Architecture}}" $(docker image ls -q)'
alias dockstopall='docker stop $(docker ps -a -q)'
alias cassandra='docker exec -it dockercassandra bash'

# Git alias
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias grb='git rebase'
alias gst='git status'
alias gsb='git status -sb'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Maven alias
alias mvnc='mvn clean'
alias mvnp='mvn package'
alias mvncp='mvn clean package'
alias mvncpst='mvn clean package -DskipTests'
alias mvnci='mvn clean install'
alias mvncist='mvn clean install -DskipTests'
alias mvncisto='mvn clean install -DskipTests --offline'
alias mvnd='mvn deploy'
alias mvndst='mvn deploy -DskipTests'
alias mvncom='mvn compile'
alias mvnct='mvn clean test'
alias mvnt='mvn test'
alias mvne='mvn eclipse:eclipse'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvncv='mvn clean verify'
alias mvnag='mvn archetype:generate'
alias mvn-updates='mvn versions:display-dependency-updates'
alias mvndt='mvn dependency:tree'
alias mvns='mvn site'
alias mvnsrc='mvn dependency:sources'
alias mvndocs='mvn dependency:resolve -Dclassifier=javadoc'

# Java alias
alias msrun='java -jar -Xmx256m target/*.war --spring.profiles.active=dev --spring.output.ansi.enabled=ALWAYS'
alias ms512='java -jar -Xmx512m target/*.war --spring.profiles.active=dev --spring.output.ansi.enabled=ALWAYS'
