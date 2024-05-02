
## Features 
### Aggregation
Aggregation sample *$match* and *$group*: 
```js
db.sightings.aggregate([
  { $match: { species_common: 'Eastern Bluebird' } },
  { 
    $group: { 
        _id: '$location.coordinates', 
        number_of_sightings: { $count: {} }
    } 
  }
])
```

Aggregation sample *$sort* and *$limit*: 
```js
db.sightings.aggregate([
  { $sort: { 'location.coordinates.1': -1 } },
  { $limit: 4 }
])
```

Aggregation sample *$project*: 
```js
db.sightings.aggregate([
  { 
    $project: {
      'species_common': 1,
      'date': 1,
      '_id': 0
    }
  }
])
```

Aggregation sample *$set*: 
```js
db.birds.aggregate([
  { 
    $set: { 'class': 'bird' }
  }
])
```

Aggregation sample *$match* and *$count*: 
```js
db.sightings.aggregate([
  { 
    $match: { 
      species_common: 'Eastern Bluebird',
      date: {
          $gt: ISODate('2022-01-01T00:00:00.000Z'),
          $lt: ISODate('2023-01-01T00:00:00.000Z')
      }
    }
  }, {
    $count: 'bluebird_sightings_2022'
  }
])
```

## Tools
### mongosh
Install: `brew install mongosh`
Connect: `mongosh "mongodb+srv://[CLUSTER_NAME]/" --apiVersion 1 --username jgisson`

### Compass
Install: `brew install --cask mongodb-compass`

### Export / Import Data
* Export / dump: `mongodump --uri=$CONNECTION_STRING -db $DB_NAME`
* Export / dump ex: `mongodump --uri="mongodb://localhost:27017" -db $DB_NAME`
* Import Data - DB : `mongorestore dump/`
* Import Data - collection : `mongorestore --nsInclude=$DB_NAME.COL_NAME dump/`

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