const config = require('./esbuild.config');

(async () => {
  let esbuild = require('esbuild');

  let result = await esbuild.build({
    ...config,
    metafile: true,
    minify: true,
  });

  let text = await esbuild.analyzeMetafile(result.metafile);
  console.log(text);
  require('fs').writeFileSync('meta.json', JSON.stringify(result.metafile));
})();
