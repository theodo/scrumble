const fs = require('fs-extra');
const { gzipSync, brotliCompressSync } = require('zlib');

const config = require('./esbuild.config');

const staticCompress = {
  name: 'staticCompress',
  setup(build) {
    const ALLOWED_EXTENSIONS = ['.svg', '.css', '.js', '.html'];
    build.onEnd((result) => {
      const outFiles = Object.keys(result.metafile.outputs).filter((f) =>
        ALLOWED_EXTENSIONS.some((e) => f.endsWith(e))
      );

      outFiles.forEach((file) => {
        const contents = fs.readFileSync(file);
        console.log('Compressing (gzip)', file);
        fs.writeFileSync(`${file}.gz`, gzipSync(contents));
        console.log('Compressing (brotli)', file);
        fs.writeFileSync(`${file}.br`, brotliCompressSync(contents));
      });
    });
  },
};

(async () => {
  let esbuild = require('esbuild');

  let result = await esbuild.build({
    ...config,
    metafile: true,
    minify: true,
    plugins: [...config.plugins, staticCompress],
  });

  let text = await esbuild.analyzeMetafile(result.metafile);
  console.log(text);
  require('fs').writeFileSync('meta.json', JSON.stringify(result.metafile));
})();
