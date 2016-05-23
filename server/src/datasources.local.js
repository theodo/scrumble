// this file override the datasource.json file
module.exports = {
  db: {
    name: 'scrumble',
    connector: 'postgresql',
    host: process.env.DB_PORT_5432_TCP_ADDR || 'localhost',
    port: process.env.DB_PORT_5432_TCP_PORT || 5432,
    database: process.env.DB_DATABASE || 'postgres',
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || ''
  },
};
