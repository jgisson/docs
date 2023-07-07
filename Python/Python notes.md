
# Python notes

# Installation
## Ubuntu : version par défaut
* Mise à jour : `sudo apt update && sudo apt upgrade`
* Installation : `sudo apt install python3`
* Install Python tools : `sudo apt install python3.11-dev python3.11-venv`

## Ubuntu : Installer une version spécifique 
* Ajouter le repo Python : `sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt update`
* Installer une version : `sudo apt install python3.11`
* Mettre par défaut : 
  - `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 110`
  - `sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100`
  - `sudo update-alternatives --config python3`
* Install Python tools : `sudo apt install python3.11-dev python3.11-venv`
* Fix "ModuleNotFoundError: No module named 'apt_pkg' error":
  - `cd /usr/lib/python3/dist-packages`
  - `sudo cp apt_pkg.cpython-***-linux-gnu.so apt_pkg.so`
  - ex: `sudo cp apt_pkg.cpython-310-x86_64-linux-gnu.so apt_pkg.so`

## Commandes 
* Vérifier la version : `python3 --version`
* Installer un env : 
  - Créer l'environnement : `python3 -m venv $ENV_NAME`
  - Activer l'environnement : `source $ENV_NAME/bin/activate`
  - Désactiver l'environnement : `deactivate`
