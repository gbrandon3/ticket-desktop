const { defineConfig } = require('drizzle-kit');

const usePostgres = Boolean(process.env.DATABASE_URL || process.env.DB_DIALECT === 'postgresql');

module.exports = defineConfig(
  usePostgres
    ? {
        dialect: 'postgresql',
        schema: './server/orm/schema.pg.js',
        out: './supabase/migrations',
        dbCredentials: {
          url: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/postgres',
        },
      }
    : {
        dialect: 'sqlite',
        schema: './server/orm/schema.js',
        out: './drizzle',
        dbCredentials: {
          url: process.env.TICKETS_DB_PATH || './data/tickets.sqlite',
        },
      }
);
