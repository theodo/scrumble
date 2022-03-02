const coffeeScriptPlugin = require('esbuild-coffeescript');
const { lessLoader } = require('esbuild-plugin-less');

require('dotenv').config({path: '../.env'});

const config = {
  entryPoints: {
    app: 'src/app.coffee',
  },
  loader: {
    '.html': 'text',
    '.svg': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file',
  },
  define: {
    API_URL: `"${process.env.API_URL}"` || '"http://localhost:8000/api/v1"',
    GOOGLE_CLIENT_ID:
    `"${process.env.GOOGLE_CLIENT_ID}"` ||
      '"846194931476-lnslq69phmckpsul3ttjrcqk7msqmlqf.apps.googleusercontent.com"',
    TRELLO_KEY: `"${process.env.TRELLO_KEY}"` || '"62bfdf783665fa1f28e1d3e324974106"',
  },
  keepNames: true,
  bundle: true,
  outdir: 'public/js',
  plugins: [coffeeScriptPlugin(), lessLoader()],
};

module.exports = config;
