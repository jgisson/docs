
## Tools
### mongosh
Install: `brew install mongosh`
Connect: `mongosh "mongodb+srv://[CLUSTER_NAME]/" --apiVersion 1 --username jgisson`

### Compass
Install: `brew install --cask mongodb-compass`

## Atlas CLI

- Login: `atlas auth register`
- Create Cluster on AWS: `atlas setup --clusterName myAtlasClusterEDU --provider AWS --currentIp --skipSampleData --username myAtasDBUser --password myatlas-001`
- Select DB : `use myDB`

## mongo shell
- Create collection (explicit) : `db.createCollection( <name>, <options>)`
- Create collection (implicit) :
```
db.myNewCollection2.insertOne( { x: 1 } )
db.myNewCollection3.createIndex( { y: 1 } )
```