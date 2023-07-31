Installation  Macbook / Mac OS

# Commons
* Microsoft 365 (download)
* Install Homebrew :
  * `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  * Ajouter brew au PATH (.zshrc / .zshrc.custom) : **export PATH=/opt/homebrew/bin:$PATH** et **export PATH=/opt/homebrew/sbin:$PATH** 
* VS Code : `brew install --cask visual-studio-code`
* Install Oh My zsh : `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
* iterm2 :  `brew install --cask iterm2`
* Slack : `brew install --cask slack`
* VLC: `brew install --cask vlc`
* Postman: `brew install --cask postman`
* ?? Alfred ??

# devs
* Install sdkman : 
  * `curl -s "https://get.sdkman.io" | bash`
  * `source "$HOME/.sdkman/bin/sdkman-init.sh"`
* Install IntelliJ (download)
* Conteneurs
  * Colima : `brew install colima`
  * Docker : `brew install docker docker-compose`
  * start : `colima start`
  * start with k3s: `colima start -k`
  * start with Intel Arch: `colima start -a x86_64`
* htop: `brew install htop`
* Install nvm
  * `brew install nvm`
  * `mkdir ~/.nvm`
  * Configuration shell (.bashrc / .zshrc)
```sh
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
```
* Install httpie: `brew install httpie`
