# MIG Template sample

1. Template:
```sh
gcloud compute instance-templates create nucleus-backend-template \
   --region=us-west3 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=n1-standard-1 \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script="#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '\"\$HOSTNAME\"'/' /var/www/html/index.nginx-debian.html"
```

2. MIG 
`gcloud compute instance-groups managed create nucleus-backend-group --template=nucleus-backend-template --size=2 --zone=us-west3-b --`

```sh
gcloud compute firewall-rules create allow-tcp-rule-154 \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80
```

4. `gcloud compute addresses create nucleus-ipv4-1 --ip-version=IPV4 --global`

5. gcloud compute health-checks create http nucleus-http-basic-check --port 80

6. gcloud compute backend-services create nucleus-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=nucleus-http-basic-check \
  --global

7. gcloud compute backend-services add-backend nucleus-backend-service \
  --instance-group=nucleus-backend-group \
  --instance-group-zone=us-west3-b \
  --global

8. gcloud compute url-maps create nucleus-map-http --default-service nucleus-backend-service

9. gcloud compute target-http-proxies create nucleus-http-lb-proxy --url-map nucleus-map-http

10. gcloud compute forwarding-rules create nucleus-http-content-rule \
    --address=nucleus-ipv4-1\
    --global \
    --target-http-proxy=nucleus-http-lb-proxy \
    --ports=80

Si Erreur "Le groupe d'instance n'a pas de port nommé"
  => `gcloud compute instance-groups unmanaged set-named-ports nucleus-backend-group --named-ports=http:80`
