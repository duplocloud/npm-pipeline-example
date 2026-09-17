import * as request from 'supertest';
import { app, server } from './index';

describe('Test the root path', () => {
  afterEach(() => {
    server.close();
  });
  test('It should respond with "Hello, world!"', async () => {
    const response = await request(app).get('/');
    expect(response.text).toEqual('Hello, world!');
    expect(response.status).toBe(200);
  });
});

describe('GET /version', () => {
  afterEach(() => {
    server.close();
  });
  test('returns 200 with name, version, and versionRequestCount', async () => {
    const response = await request(app).get('/version');
    expect(response.status).toBe(200);
    expect(response.body.name).toBe('duplo-pipeline-example');
    expect(response.body.version).toBe('1.0.0');
    expect(typeof response.body.versionRequestCount).toBe('number');
  });
  test('versionRequestCount increments on each call', async () => {
    const first = await request(app).get('/version');
    const second = await request(app).get('/version');
    expect(second.body.versionRequestCount).toBe(first.body.versionRequestCount + 1);
  });
});

describe('GET /health', () => {
  afterEach(() => {
    server.close();
  });
  test('returns 200 with status "ok" and numeric uptime', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ok');
    expect(typeof response.body.uptime).toBe('number');
    expect(response.body.uptime).toBeGreaterThanOrEqual(0);
  });
});
