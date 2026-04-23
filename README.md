# ldp-app

An example Node.js application demonstrating the `ldp-service` Express middleware. It provides a [W3C Linked Data Platform](http://www.w3.org/2012/ldp/) (LDP) server with an interactive RDF graph visualization, using Apache Jena Fuseki as the triple store.

## Prerequisites

- [Node.js](http://nodejs.org) v22 or later
- [Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) running with a dataset configured

## Build

From the workspace root:

```
npm install
cd ldp-app
npm run build
```

## Configuration

Edit `config.json` to match your environment:

```json
{
  "scheme": "http",
  "host": "localhost",
  "port": 3000,
  "context": "/univ/",
  "storageImpl": "jena-storage-service",
  "jenaURL": "http://localhost:3030/univ/"
}
```

| Property       | Description |
|----------------|-------------|
| `scheme`       | `http` or `https` |
| `host`         | Hostname the server binds to |
| `port`         | Port the server listens on |
| `context`      | URL path prefix for LDP resources |
| `storageImpl`  | Storage backend module name |
| `jenaURL`      | Fuseki dataset endpoint URL |

These values can be overridden by environment variables. The app also recognizes `VCAP_APP_HOST`, `VCAP_APP_PORT`, `HOSTNAME`, and `LDP_BASE` for cloud deployments.

## Running

Start Fuseki with your dataset, then:

```
npm start
```

Point your browser to `http://localhost:3000/`.

## What It Does

The Express application (`src/app.ts`) sets up three layers:

1. **Static files** -- Serves the web UI from `public/` (HTML, CSS, client-side JavaScript).

2. **Visualization endpoint** (`/v?uri=<resourceURI>`) -- Defined in `src/viz.ts`. Fetches a named graph from Fuseki, parses the Turtle response with `rdflib`, extracts a label (`dcterms:title` or `dcterms:identifier`) and all non-literal object references, and returns JSON. The client renders this as an interactive D3.js force-directed graph.

3. **LDP middleware** -- Mounted from `ldp-service`. Handles GET, PUT, POST, and DELETE for RDF resources and containers under the configured context path.

The web UI provides a CRUD panel for direct LDP operations and a graph explorer that expands resource links on click.

## Contributors

Many thanks to Steve Speicher, Sam Padgett, and Jim Amsden for their valuable contribution to LDP and this sample application.

## License

Licensed under the Apache License, Version 2.0. See <http://www.apache.org/licenses/LICENSE-2.0>.
