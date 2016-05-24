gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'
addsrc = require 'gulp-add-src'

gulp.task 'coffee-public', (done) ->
  gulp.src ["#{__dirname}/../src/**/*.coffee", "!#{__dirname}/../src/**/*test.coffee"]

  .pipe coffee
    bare: true
  .pipe addsrc ["#{__dirname}/../src/**/*.js", "!#{__dirname}/../src/**/*test.js"]
  .pipe concat 'app.js'
  .on 'error', gutil.log
  .pipe gulp.dest "#{__dirname}/../public/js/"
  .on 'end', done
  return
