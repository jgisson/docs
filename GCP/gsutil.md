
## General

Créer un bucket : `gsutil mb gs://$MY_BUCKET_NAME`

Lister les buckets : `gsutil ls`
Lister les objets d'un bucket : `gsutil ls gs://$BUCKET_NAME`
Lister toutes les versions d'un objet : `gsutil ls -a gs://$BUCKET_NAME/gs_object_name`

## Transfert
Copier un fichier en vers GS: `gsutil cp localfile gs://$BUCKET_NAME/gs_object_name`
Ajouter une version vers GS: `gsutil cp -v localfile gs://$BUCKET_NAME/gs_object_name`
Copier un fichier en local: `gsutil cp gs://$BUCKET_NAME/gs_object_name localfile`
Copier une version d'un objet en local: `gsutil cp gs://$BUCKET_NAME/gs_object_name#version localfile`
Copier plusieurs fichier: `gsutil cp gs://$BUCKET_NAME/object_prefix* ./`
Synchro de dossier: `gsutil rsync -r ./firstlevel gs://$BUCKET_NAME/firstlevel`
Copie entre buckets: `gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg gs://$MY_BUCKET_NAME_2/cat.jpg`

## Versioning
Afficher le mode de versioning: `gsutil versioning get gs://$BUCKET_NAME`
Activer le versioning: `gsutil versioning set on gs://$BUCKET_NAME`

## Cycle de vie
Afficher le cycle de vie: `gsutil lifecycle get gs://$BUCKET_NAME`
Mettre un cycle de vie: `gsutil lifecycle set life.json gs://$BUCKET_NAME`
Fichier de config cycle de vie (life.json)
```json
{
  "rule":
  [
    {
      "action": {"type": "Delete"},
      "condition": {"age": 31}
    }
  ]
}
```

## Config
Générer fichier .boto: `gsutil config -n`

### Chiffrement
Générer une clé: `python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'`

## ACL 
Liste des ACL d'un objet: `gsutil acl get gs://$BUCKET_NAME/setup.html`
Rendre un objet privé: `gsutil acl set private gs://$BUCKET_NAME/setup.html`
Visible de tous (Public): `gsutil acl ch -u AllUsers:R gs://$BUCKET_NAME/setup.html`
