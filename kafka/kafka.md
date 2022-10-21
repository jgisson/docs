
# Kafka Notes et Astuces

## Serveurs et environements
### Démarrer un cluster Kafka standalone avec Docker 
Démarrer Kafka avec le fichier docker-compose *kafka-docker-compose.yml* : 
`docker compose -f kafka-docker-compose.yml up -d`

### Installer et configurer les CLI
TODO

## Topics

La gestion des topics se fait via un CLI *kafka-topics* ou *kafka-topics.sh* fournit avec le cluster.
Remarques:
* Pour les nouvelles versions, supérieur à v2.2+, il faut passer le serveur Kafka dans les paramètres pour spécifier le cluster 
* Dans les anciennes versions,  supérieur à v2.2, il faut passer le serveur Zookeeper dans les paramètres pour spécifier le cluster 

### Bonnes pratiques : 
* Ne pas mettre de caratères point / '.' et tiret bas / '_' dans les noms des topics

### Commandes utiles : 
* Créer un Topic : `kafka-topics --create --topic users-registrations --bootstrap-server broker:9092 --replication-factor 2 --partitions 1`
* Créer un Topic (avant v2.2): `kafka-topics.sh --create --topic users-registrations --replication-factor 1 --partitions 2 --zookeeper localhost:2181`
* Lister des Topics: `kafka-topics --list --bootstrap-server=localhost:9092`
* Détails d'un Topic : `kafka-topics --bootstrap-server=localhost:9092 --describe --topic users-registrations`
* Supprimer un Topic : `kafka-topics --bootstrap-server=localhost:9092 --delete --topic users-registrations`
* Lire un topic : 
```shell
kafka-console-consumer --topic output-topic \
 --bootstrap-server broker:9092 \
 --from-beginning \
 --property print.key=true \
 --property key.separator=" : "
```
* Produire des messages:
  * `kafka-console-producer.sh --broker-list localhost:9092 --topic users-registrations`
  * `kafka-console-producer.sh --broker-list localhost:9092 --topic users-registrations < input.txt`
  * `kafka-console-producer.sh --broker-list localhost:9092 --topic users-registrations --property parse.key=true --property key.separator=:`
