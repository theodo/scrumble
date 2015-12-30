gulp = require 'gulp'
gulp.task 'please-wait-css', (done) ->
  gulp.src [
    'bower_components/please-wait/build/please-wait.css'
  ]
  .pipe gulp.dest('public/css')
  .on 'end', done
  return
gulp.task 'please-wait-js', (done) ->
  gulp.src [
    'bower_components/please-wait/build/please-wait.min.js'
  ]
  .pipe gulp.dest('public/js')
  .on 'end', done
  return
