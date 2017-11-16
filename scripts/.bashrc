#Docker configuration
docker-machine start default
# eval $(docker-machine env default)
export DOCKER_HOST=tcp://192.168.99.100:2376
export DOCKER_MACHINE_NAME=default
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH='C:\Users\jgisson\.docker\machine\machines\default'
export DOCKER_IP=$(docker-machine ip)
export NO_PROXY=$NO_PROXY,$DOCKER_IP

# Alias standard
alias ll='ls -l'
alias la='ls -al'

# Docker alias
alias dockps='docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Names}}"'
alias dock-dbbpm='winpty docker exec -it bpm-mysql bash'
alias dock-dbdfce='winpty docker exec -it dockercassandra bash'

# Java alias
alias msrun='java -jar -Xmx256m target/*.war --spring.profiles.active=dev --spring.output.ansi.enabled=ALWAYS'
alias msregistry='java -jar -Xmx256m target/*.war --spring.profiles.active=prod,native,swagger --spring.output.ansi.enabled=ALWAYS'

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
alias mvnpack='mvn clean package -DskipTests'
alias mvncie='mvn clean install eclipse:eclipse'
alias mvnci='mvn clean install'
alias mvncist='mvn clean install -DskipTests'
alias mvncisto='mvn clean install -DskipTests --offline'
alias mvne='mvn eclipse:eclipse'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvncv='mvn clean verify'
alias mvnd='mvn deploy'
alias mvncp='mvn clean package'
alias mvnp='mvn package'
alias mvnc='mvn clean'
alias mvncom='mvn compile'
alias mvnct='mvn clean test'
alias mvnt='mvn test'
alias mvnag='mvn archetype:generate'
alias mvn-updates='mvn versions:display-dependency-updates'
alias mvntc7='mvn tomcat7:run' 
alias mvntc='mvn tomcat:run'
alias mvnjetty='mvn jetty:run'
alias mvndt='mvn dependency:tree'
alias mvns='mvn site'
alias mvnsrc='mvn dependency:sources'
alias mvndocs='mvn dependency:resolve -Dclassifier=javadoc'

