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

describe('GET /health', () => {
  afterEach(() => {
    server.close();
  });
  test('returns 200 with JSON status, version, and uptime', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.headers['content-type']).toMatch(/application\/json/);
    expect(response.body.status).toBe('ok');
    expect(typeof response.body.version).toBe('string');
    expect(typeof response.body.uptime).toBe('number');
  });
});
