
# Docker notes
 
## Rechercher une image
`docker search cassandra`
	
## Download image
`docker pull [registry/image/tag]`

## List images in local repo:	
`docker images`
	
## Supprimer une image
* `docker rmi <image-id  || image-name>`
* Supprimer toutes les images non utisées / taguées : `docker image prune`

## Monter un container (instance d'image docker): 
* `docker-compose up -d (fichier par defaut docker-compose.yml)`
* `docker-compose -f sonar.yml up -d`
* `docker-compose -f cassandra.yml up -d`
* `docker run -p 8777:8080 -p 8888:8001 -e KIE_DEMO=false -d --name jbpm-workbench jboss/jbpm-workbench-showcase:6.4.0.Final`
* `docker run --name some-nginx -v C:\instances\nginx\html:/usr/share/nginx/html:ro --publish 80:80 -d nginx`
	
## Supprimer un container
* `docker rm <container id  || container-name>`
* Supprimer tout les containers a: `docker container prune`
	
## Start / stop
* `docker start <container-id  || container-name>`	
* `docker stop <container-id  || container-name>`
* `docker stop $(docker ps -a -q)`
	
## tail
* `docker logs <container-id  || container-name>`
* `docker logs -f <container-id  || container-name>`
* `docker logs --follow <container-id  || container-name>`
	
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

## [Linux] ajouter un user au groupe docker
sudo usermod -aG docker "$(whoami)"

## [Windows - Docker Toolbox] créer une machine virtualbox linux docker
* `docker-machine create -d "virtualbox" --virtualbox-cpu-count "2" --virtualbox-disk-size "40000" --virtualbox-memory "4096" default`
* `docker-machine create -d virtualbox --engine-env HTTP_PROXY=http://user:pass@10.192.19.3:3128 --virtualbox-cpu-count "2" --virtualbox-disk-size "60000" --virtualbox-memory "4096" default`
* `docker-machine start default`
* `docker-machine env default`

## [Windows - Docker Toolbox] se connecter sur la machine docker
`docker-machine ssh [vm-name]`
	
## [Windows - Docker Toolbox] se connecter au container
`winpty docker exec -it <container-id> bash`
	
## [Windows - Docker Toolbox] Config proxy docker:
* Connexion à la machine docker: `docker-machine ssh default`
* Editer le fichier config: `sudo vi /var/lib/boot2docker/profile`
* Chnager la variable HTTP_PROXY
