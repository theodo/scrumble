const config = require('./esbuild.config');

require('esbuild')
  .serve({ servedir: 'public', port: 9876 }, config)
  .then((server) => {
    console.log('watching...', server.port);
  });
