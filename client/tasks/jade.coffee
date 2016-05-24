gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
templateCache = require 'gulp-angular-templatecache'

gulp.task 'jade', (done) ->
  gulp.src(["#{__dirname}/../src/**/*.jade"])
    .pipe(jade(doctype: 'html'))
    .on 'error', gutil.log
    .pipe(templateCache(
      filename: 'templates.js'
      module: 'app.templates'
      standalone: true))
    .on 'error', gutil.log
    .pipe gulp.dest("#{__dirname}/../public/js")
    .on 'end', done
  return
