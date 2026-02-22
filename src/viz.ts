/*
 * Copyright 2014 IBM Corporation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Visualization endpoint: fetches a named graph from Fuseki,
 * extracts the resource label and non-literal object references,
 * and returns them as JSON for the D3 force-directed graph.
 */

import express from 'express';
import * as rdflib from 'rdflib';
import type { AppEnv } from './env.js';

export function vizRoute(env: AppEnv): express.Router {
  const router = express.Router();
  const jenaURL = env.jenaURL as string;
  const DCTERMS = rdflib.Namespace('http://purl.org/dc/terms/');

  router.get('/v', async (req, res) => {
    const uri = req.query.uri as string;
    if (!uri) {
      res.status(400).json({ error: 'uri parameter required' });
      return;
    }

    try {
      const resp = await fetch(`${jenaURL}data?graph=${encodeURIComponent(uri)}`, {
        headers: { Accept: 'text/turtle' },
      });
      if (resp.status !== 200) {
        res.status(resp.status).json({ error: 'Not found' });
        return;
      }

      // Fuseki returns PREFIX syntax; rdflib expects @prefix syntax
      const body = (await resp.text()).replace(
        /^PREFIX\s+(\S+)\s+(<[^>]+>)/gm,
        '@prefix $1 $2 .'
      );
      const graph = rdflib.graph();
      rdflib.parse(body, graph, uri, 'text/turtle');

      const node = rdflib.sym(uri);

      // Get label: dcterms:title, dcterms:identifier, or last path segment
      const label =
        graph.anyValue(node, DCTERMS('title')) ??
        graph.anyValue(node, DCTERMS('identifier')) ??
        uri.split('/').filter(Boolean).pop() ??
        uri;

      // Get all non-literal object references
      const stmts = graph.statementsMatching(node, null, null);
      const references = stmts
        .filter(
          (s) =>
            s.object.termType === 'NamedNode' ||
            s.object.termType === 'BlankNode'
        )
        .map((s) => ({
          predicate: s.predicate.value,
          predicateLabel: s.predicate.value.split(/[#/]/).pop(),
          object: s.object.value,
        }));

      res.json({ uri, label, references });
    } catch (err) {
      console.error('Visualization error:', err);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

  return router;
}
