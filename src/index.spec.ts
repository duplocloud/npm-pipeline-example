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
