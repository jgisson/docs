
# Docker notes
 
## Rechercher une image
`docker search cassandra`
	
## Download image
`docker pull`

## List images in local repo:	
`docker images`
	
## Supprimer une image
`docker rmi <image-id  || image-name>`

## Monter un container (instance d'image docker): 
* `docker-compose up -d (fichier par defaut docker-compose.yml)`
* `docker-compose -f sonar.yml up -d`
* `docker-compose -f cassandra.yml up -d`
* `docker run -p 8777:8080 -p 8888:8001 -e KIE_DEMO=false -d --name jbpm-workbench jboss/jbpm-workbench-showcase:6.4.0.Final`
	
## Supprimer un container
`docker rm <container id  || container-name>`
	
## Start / logs / stop
* `docker start <container-id  || container-name>`	
* `docker stop <container-id  || container-name>`
* `docker logs <container-id  || container-name>`
	
## tail
`docker logs -f <container-id  || container-name>`
`docker logs --follow <container-id  || container-name>`
	
## Lier les containers
`docker run --name myadmin --net=cnpdocker_default -d --link bpm-mysql:db -p 8080:80 phpmyadmin/phpmyadmin`

## Toutes les caracteristiques du container:
`docker inspect <container-id  || container-name>`
		
## Liste de tous les containers: 
* `docker ps -a`
* `docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Names}}"`
	
## Liste des containers up: 
`docker ps`

## Copier des fichiers: 
`docker cp <local-file> <container-id:desc-path>`

## Docker volume:
* Lister les volumes: `docker volume ls`
* Supprimer l'espace non utilisé: `docker volume rm $(docker volume ls -qf dangling=true)` 
	
## [Windows] créer une machine virtualbox linux docker
* `docker-machine create -d "virtualbox" --virtualbox-cpu-count "2" --virtualbox-disk-size "40000" --virtualbox-memory "4096" default`
* `docker-machine create -d virtualbox --engine-env HTTP_PROXY=http://user:pass@10.192.19.3:3128 --virtualbox-cpu-count "2" --virtualbox-disk-size "60000" --virtualbox-memory "4096" default`
* `docker-machine start default`
* `docker-machine env default`

## [Windows] se connecter sur la machine docker
`docker-machine ssh [vm-name]`
	
## [Windows] se connecter au container
`winpty docker exec -it <container-id> bash`
	
## [Windows] Config proxy docker:
* Connexion à la machine docker: `docker-machine ssh default`
* Editer le fichier config: `sudo vi /var/lib/boot2docker/profile`
* Chnager la variable HTTP_PROXY
