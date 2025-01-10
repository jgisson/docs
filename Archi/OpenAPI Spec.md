# OAS

## High-Level Structure

The [OpenAPI Object](https://spec.openapis.org/oas/v3.1.0.html#openapi-object) describes the root of the document and references several objects that include:

- Info Object: Provides high-level information about the API being described.
- Paths Object: Describes the operations the API provides.
- Components Object: The object that houses all reusable objects within a given OpenAPI description (more on this later).

### Object Info

It provides the means to describe high-level information including the title, summary, and description information that applies to the entire API and other usage aspects, such as the license and the terms of service.

Example:
```yaml
info:
  title: OpenAPI Basics API
  description: |
    An example of an Info Object in an OpenAPI description

    ## Introduction to API

    This provides a high-level summary. An image is provided below:

    ![Image embedded in OpenAPI description](example-image.png)

    These are the services levels available:

    | Name | Description |
    | --- | --- |
    | Basic | Free tier available to all consumers |
  version: 0.0.1 
```

## Paths Object (Describing API Shape)

The most significant section in an OpenAPI description is the Paths Object. The Paths Object is the key resource for API consumers because it associates a given URL and HTTP method to one or more Operations.

* Path Item Object (URL) : `/pets/{petId}:`
  - Operation Objects (HTTP Method - one or more): `get:`
    - summary
    - tags
    - Parameter Object (Path, Query, Header, Cookie)
    - Request Body Object (zero or one)
    - Responses Objects

![OAS Objects schema](./OpenAPI%20-%20Objects.png "OAS Objects")

### Responses

All Request Body and Response Objects provide a description of how the data is encoded, which is done using a Media Type Object:
* description
* headers
* Media Type Object
  - schema (JSON Schema)
    - title
    - description
    - properties
    - ...

![OAS Requests and Responses schema](./OpenAPi%20-%20Requests%20and%20Responses.png "OAS Requests and Responses")

``` yaml
description: Response payload including expected HTTP headers
headers:
  "x-example-header":
    description: Example header using deprecated x- nomenclature
    schema:
      type: string
content:
  application/json:
    schema:
      type: object
      required:
        - names
      properties:
        names:
          type: array
          items:
            type: string
            minLength: 1
            maxLength: 100
            pattern: ^\w$
          maxItems: 5
      additionalProperties: false
```

### Objects That Can Be Reused

The available properties are as follows (not all of which are described previously):
* Callbacks
* Examples.
* Headers
* Links
* Path Items
* Parameters
* Request Bodies
* Responses
* Schemas
* Security Schemes

``` yaml
paths:
  /pets/{petId}:
    $ref: "#/components/pathItems/petById"
components:
  pathItems:
    petById:
      get:
        summary: Info for a specific pet
        operationId: showPetById
        tags:
          - pets
        parameters:
          - name: petId
            in: path
            required: true
            description: The id of the pet to retrieve
            schema:
              type: string
        responses:
          "200":
            description: Expected response to a valid request
            content:
              application/json:
                schema:
                  $ref: "#/components/schemas/Pet"
          default:
            description: unexpected error
            content:
              application/json:
                schema:
                  $ref: "#/components/schemas/Error"
  schemas:
    Pet:
      type: object
    Error:
      type: object
```

### Supported Security Requirements

OpenAPI currently provides support for five different security schemes through the Security Scheme Object, including the following:
* API Key (apiKey)
* HTTP (http) : Basic and Bearer
* Mutual TLS (mutualTLS)
* OAuth 2.0 (oauth2)
* OpenID Connect (openIdConnect)



## Tools

- [Redoc](https://github.com/Redocly/redoc)