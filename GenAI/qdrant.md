# Qdrant 

Vector Database Open Source

## Collections
A collection is a named set of points (vectors with a payload) among which you can search

### Create collection
* distance: best way to mesure vector
* size: number of dimension

## WebUI
Go to Dashboard -> Collections

```json
// List all collections
GET collections

PUT collections/{collection_name}
{
  "vectors": {
    "size": 384,
    "distance": "Cosine"
  }
}

// Create indexes
PUT /collections/astek_resumes/index
{
    "field_name": "metadata_name",
    "field_schema": "metadata type and options [keyword, text, integer, bool, geo, ...]"
}

// Get collection info
GET collections/{collection_name}

POST collections/{collection_name}/points/scroll
{
  "limit": 10
}

// List points in a collection, using filter
POST collections/{collection_name}/points/scroll
{
  "limit": 10,
  "filter": {
    "must": [
      {
        "key": "city",
        "match": {
          "any": [
            "San Francisco",
            "New York",
            "Berlin"
          ]
        }
      }
    ]
  }
}
```