
# WSL notes

## Commandes 
* Voir le statut : `wsl --status`
* Mettre à jour WSL : `wsl --update`
* Arrêter toutes le distributions : `wsl --shutdown`

## Commandes distribution
* Lister des distributions : ` wsl -l -o` // `wsl --list --online`
* Installer une distribution : `wsl --install -d <Distribution Name>`
  - Mettre à jour la distribution. Sur Ubuntu : `sudo apt update && sudo apt upgrade`
* Lister des distributions installées : `wsl -l -v`
* Définir la distribution par défaut : `wsl -s <Distribution Name>` // wsl --setdefault <DistributionName>
* Définir la version WSL pour une distribution : `wsl --set-version <Distribution Name> 2`
* Arrêter une distrib : `wsl --terminate <Distribution Name>`
* Exporter une distrib : `wsl --export <Distribution Name> <FileName>`
* Importer une distrib : `wsl --import <Distribution Name> <InstallLocation> <FileName>`
* Désinstaller une distrib (perte de données): `wsl --unregister <Distribution Name>`

## VS Code et WSL
* VS Code est complétement intégré à WSL
  - Il est possible de lancer VS Code depuis WSL : `code .` C'est l'application Windows qui se lance, mais connecter sur la distrib.
  - Les extensions WSL sont installées par défaut 
  - Les autres extensions sont à installer, car elles sont spécifiques à la distribution (Les extentions du poste ne sont pas reprises)

## Remarques:
* Par défaut, les variables d'env Windows sont propagé, y compris la $PATH. Attention aux conflits
