import * as express from 'express';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const { version } = require('../package.json');

export const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', version, uptime: process.uptime() });
});

export const server = app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
