// this file override the datasource.json file
module.exports = {
  db: {
    name: 'scrumble',
    connector: 'postgresql',
    url: process.env.DATABASE_URL,
    ssl: true,
  },
};
