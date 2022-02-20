const config = require('./esbuild.config');

require('esbuild')
  .serve(
    { servedir: 'public', port: 9876 },
    { ...config, minify: true, minifyIdentifiers: false }
  )
  .then((server) => {
    console.log('watching...', server.port);
  });
