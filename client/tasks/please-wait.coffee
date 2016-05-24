gulp = require 'gulp'

gulp.task 'please-wait-css', (done) ->
  gulp.src [
    "#{__dirname}/../bower_components/please-wait/build/please-wait.css"
  ]
  .pipe gulp.dest("#{__dirname}/../public/css")
  .on 'end', done
  return
gulp.task 'please-wait-js', (done) ->
  gulp.src [
    "#{__dirname}/../bower_components/please-wait/build/please-wait.min.js"
  ]
  .pipe gulp.dest("#{__dirname}/../public/js")
  .on 'end', done
  return
