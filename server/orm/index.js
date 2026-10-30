const { drizzle } = require('drizzle-orm/node-sqlite');
const sqlite = require('../db');
const schema = require('./schema');
const schemaPg = require('./schema.pg');

const orm = drizzle({ client: sqlite, schema });

function createPostgresOrm(connectionUrl = process.env.DATABASE_URL) {
  const { drizzle: drizzlePg } = require('drizzle-orm/node-postgres');
  return drizzlePg({ connection: connectionUrl, schema: schemaPg });
}

module.exports = { orm, schema, schemaPg, createPostgresOrm };
