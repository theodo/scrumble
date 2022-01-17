// this file override the datasource.json file
module.exports = {
  db: {
    name: 'scrumble',
    connector: 'postgresql',
    host: 'db',
    port: 5432,
    database: process.env.DB_DATABASE || 'postgres',
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
  },
};
