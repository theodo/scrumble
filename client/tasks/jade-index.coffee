gulp = require 'gulp'
jade = require 'gulp-jade'
gutil = require 'gulp-util'

gulp.task 'jade-index', (done) ->
  gulp.src(["#{__dirname}/../src/index.jade"])
    .pipe(jade())
    .on 'error', gutil.log
    .pipe gulp.dest("#{__dirname}/../public")
    .on 'end', done
  return
