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
 * Initializes the ldp-server and opens a client view for
 * accessing LDP resources and displaying a graph of their links.
 */

import express, { type Request, type Response, type NextFunction } from 'express';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { ldpService } from 'ldp-service';
import { JenaStorageService } from 'ldp-service-jena';
import { env } from './env.js';
import { vizRoute } from './viz.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log('configuration:');
console.dir(env);

const app = express();
app.use(express.static(join(__dirname, '..', 'public')));

const storage = new JenaStorageService();

try {
  await storage.init(env);
  app.use(vizRoute(env));
  app.use(ldpService(env, storage));
} catch (err) {
  console.error(err);
  console.error("Can't initialize the Jena storage service.");
}

// error handling
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.listen(env.listenPort, env.listenHost, () => {
  console.log('App started on ' + env.appBase);
});
