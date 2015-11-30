gulp = require 'gulp'
deploy = require 'gulp-gh-pages'

gulp.task 'deploy', (done) ->
  gulp.src './public/**/*'
  .pipe deploy
      message: 'Update ' + new Date().toISOString() + ' --skip-ci'
    .on 'end', done
  return
