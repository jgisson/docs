

## General
Aide : `gcloud -h`
List d'Auth : `gcloud auth list`
Liste projets: `gcloud config list project`

Lister les comptes auth: `gcloud auth list`
Changer de compte auth: `gcloud config set account [USERNAME]`
Se loguer avec un compte de service: `gcloud auth activate-service-account --key-file credentials.json`

## Config 

Aide config: `gcloud config --help`
gcloud config list [--all]
gcloud config set compute/region us-central1
gcloud config get-value compute/region
export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/zone us-central1-c
gcloud config get-value compute/zone
export ZONE=$(gcloud config get-value compute/zone)

gcloud config get-value project

## Compute Engine
gcloud compute instances list [--filter="name=('gcelab2')"]

gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE

gcloud compute firewall-rules list [--filter="network='default'"]

SSH: `gcloud compute ssh $MY_VM_NAME --zone $ZONE`
SCP: `gcloud compute scp index.html $MY_VM_NAME:index.html --zone=$MY_ZONE`

gcloud compute instances add-tags gcelab2 --tags http-server,https-server
gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute firewall-rules list --filter=ALLOW:'80'

### Groupes
Template:
```sh
gcloud compute instance-templates create lb-backend-template \
   --region=us-central1 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'
```

Groups basé sur un template (2 noeuds):
```sh
gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=us-central1-a 
```

## Conteneurs GKE
Create Cluster: `gcloud container clusters create --machine-type=e2-medium --zone=us-central1-a lab-cluster`
Auth Cluster: `gcloud container clusters get-credentials lab-cluster [--project $PROJECT_ID]`
Delete Cluster: gcloud container clusters delete lab-cluster

## Cloud Functions
* Créer une Cloud Function : 
```sh
gcloud functions deploy helloWorld \
  --stage-bucket [BUCKET_NAME] \
  --trigger-topic hello_world \
  --runtime nodejs8
```
* Excécuter / tester : `gcloud functions call helloWorld --data "$DATA"`
* Voir les logs : `gcloud functions logs read helloWorld`

## AIM
Créer un compte de service: `gcloud iam service-accounts create test-service-account --display-name "test-service-account"`

## Observabilité :

gcloud logging logs list [--filter="compute"]
gcloud logging read "resource.type=gce_instance" --limit 5

gcloud services enable cloudprofiler.googleapis.com

## Région, zone et réseau

### Créer des réseaux
Liste des sous-réseaux : `gcloud compute networks list`
Créer réseau : `gcloud compute networks create [NETWORK_ID] --project=[PROJECT_ID] --subnet-mode=custom [--mtu=1460 --bgp-routing-mode=regional]`
Créer sous réseau: `gcloud compute networks subnets create [SUBNETWORK_ID] --project=[PROJECT_ID] --range=10.130.0.0/20 --stack-type=IPV4_ONLY --network=[NETWORK_ID] --region=us-central1`
Connexion VM via Tunnel IAP : `gcloud compute ssh vm-internal --zone us-central1-c --tunnel-through-iap`

### Pare-feu
Liste : `gcloud compute firewall-rules list --sort-by=NETWORK`
Créer une règle: `gcloud compute --project=qwiklabs-gcp-03-3fe5f7475774 firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=tcp:22,tcp:3389,icmp --source-ranges=0.0.0.0/0`

### Equilibrage de charge
1. Créer une adresse IP ext. stat. : `gcloud compute addresses create network-lb-ip-1 --region us-central1`
2. Créer un Health Check: `gcloud compute http-health-checks create basic-check`
3. Créer un pool cible: `gcloud compute target-pools create www-pool --region us-central1 --http-health-check basic-check`
4. Ajouter les instances au pool: `gcloud compute target-pools add-instances www-pool --instances www1,www2,www3`
5. Ajouter la règle de transfert (firewall): 
```sh
gcloud compute forwarding-rules create www-rule \
    --region  us-central1 \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool`
```

### Equilibrage de charge HTTP
1. Régle de pare-feu pour vérification d'état Google Cloud : `gcloud compute firewall-rules create fw-allow-health-check .... --source-ranges=130.211.0.0/22,35.191.0.0/16 ... `
2. Créer une adresse IP ext. stat. : `gcloud compute addresses create lb-ipv4-1 --ip-version=IPV4 --global`
3. Créer un Health Check: `gcloud compute health-checks create http http-basic-check --port 80`
4. Créez un service de backend: 
```sh
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global
```
5. Ajoutez votre groupe d'instances au backend: 
```sh
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=us-central1-a \
  --global
```
6. Créez un mappage d'URL : `gcloud compute url-maps create web-map-http --default-service web-backend-service`
7. Créez un proxy HTTP cible: `gcloud compute target-http-proxies create http-lb-proxy --url-map web-map-http`
8. Créez une règle de transfert globale:
```sh
gcloud compute forwarding-rules create http-content-rule \
    --address=lb-ipv4-1\
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80
```

## Tools
- Lancer un build: `gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/devops-image:v0.1 .`
- Deployer une app App Engine: `gcloud app deploy app.yaml`
s