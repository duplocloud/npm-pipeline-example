import * as express from 'express';
import { randomUUID } from 'crypto';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const pkg = require('../package.json');

export const app = express();
const port = process.env.PORT || 3000;

app.use((_req, res, next) => {
  res.setHeader('X-Request-ID', randomUUID());
  next();
});

// In-memory only — resets to 0 on every process restart.
let versionRequestCount = 0;

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.get('/version', (req, res) => {
  versionRequestCount += 1;
  res.json({ name: pkg.name, version: pkg.version, versionRequestCount });
});

export const server = app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
