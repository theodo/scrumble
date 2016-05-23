gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
addsrc = require 'gulp-add-src'

gulp.task 'coffee-public', (done) ->
  gulp.src ['client/**/*.coffee', '!client/**/*test.coffee']

  .pipe coffee
    bare: true
  .pipe addsrc ['client/**/*.js', '!client/**/*test.js']
  .pipe concat 'app.js'
  .on 'error', gutil.log
  .pipe gulp.dest 'public/js/'
  .on 'end', done
  return
