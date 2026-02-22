# ldp-app

[![Discourse status](https://img.shields.io/discourse/https/meta.discourse.org/status.svg)](https://forum.open-services.net/)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/OSLC/chat)

A Node.js Express application that provides a [W3C Linked Data Platform](http://www.w3.org/2012/ldp/) (LDP) server with an interactive RDF graph visualization. It uses the **ldp-service** Express middleware for LDP operations and **Apache Jena Fuseki** as the RDF triple store.

ldp-app uses the ldp-service Express middleware module which supports LDP basic and direct containers. Indirect containers and non-RDF source are not implemented.

Many thanks to Steve Speicher, Sam Padgett and Jim Amsden for their valuable contribution to LDP and this sample app.

## Architecture

ldp-app is built from several modules in the oslc4js workspace:

- **ldp-app** -- Express application entry point, static web UI, and visualization endpoint
- **ldp-service** -- Express middleware implementing the W3C LDP protocol (GET, PUT, POST, DELETE for Linked Data Platform RDF resources and containers)
- **ldp-service-jena** -- Storage backend that persists RDF graphs in Apache Jena Fuseki via its Graph Store Protocol and SPARQL endpoints
- **storage-service** -- Abstract storage interface that implements minimal storage services shared by all backends

### Server

The Express app (`src/app.ts`) serves static files from `public/`, mounts the visualization route, then mounts the LDP middleware:

1. **Static files** -- `public/index.html`, `style.css`, etc.
2. **Visualization endpoint** (`/v?uri=<resourceURI>`) -- Defined in `src/viz.ts`. Fetches a named graph from Fuseki, parses the Turtle with rdflib, extracts the resource label (`dcterms:title` or `dcterms:identifier`) and all non-literal object references (URIs and blank nodes), and returns JSON.
3. **LDP middleware** -- Handles all CRUD operations on RDF resources under the configured context path (e.g. `/univ/`).

Configuration is read from `config.json` (scheme, host, port, context path, Fuseki URL) with environment variable overrides.

### Client

The web UI (`public/index.html`) provides two main features:

**RDF Graph Visualization** -- Uses D3.js v7 to render an interactive force-directed graph. The user enters a resource URI and clicks "Explore". The app fetches the resource to get the resource's label and outgoing references, then renders the resource as a labeled node. Clicking any node expands it by fetching its references and adding child nodes and links. Already-expanded nodes are tracked to prevent re-fetching. Nodes are colored by depth and labeled with `dcterms:title`. Links are labeled with the predicate short name and include arrowhead markers.

**CRUD Panel** -- Tabbed interface for direct LDP operations using native `fetch()`:

- **GET** -- Retrieve a resource as Turtle or JSON
- **PUT** -- Update a resource with new RDF content
- **POST** -- Create a new resource in a container
- **DELETE** -- Remove a resource

## Running

### Prerequisites

- [Node.js](http://nodejs.org) v22 or later
- [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) running with a dataset configured

### Setup

Install dependencies from the workspace root:

    $ npm install

Build the TypeScript source:

    $ cd ldp-app
    $ npm run build

### Configuration

Edit `config.json` to match your environment:

```json
{
  "scheme": "http",
  "host": "localhost",
  "port": 3000,
  "context": "/univ/",
  "storageImpl": "ldp-service-jena",
  "jenaURL": "http://localhost:3030/univ/"
}
```

- **context** -- The URL path prefix for LDP resources
- **jenaURL** -- The Fuseki dataset endpoint URL

### Start

Start Fuseki with your dataset, then:

    $ npm start

Point your browser to [http://localhost:3000/](http://localhost:3000/).

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
