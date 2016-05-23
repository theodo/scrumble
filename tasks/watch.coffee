gulp = require 'gulp'
webserver = require 'gulp-webserver'
runSequence = require 'run-sequence'

gulp.task 'webserver', ['build'], ->
  gulp.src 'public'
  .pipe webserver
      livereload: true
      fallback: 'index.html'
      host: '127.0.0.1'
      port: 8008

gulp.task 'watch', ->
  runSequence 'webserver', ->
    gulp.watch 'client/assets/**/*', ['assets']
    gulp.watch 'client/**/*.coffee', ['coffee-public']
    gulp.watch 'client/index.jade', ['jade-index']
    gulp.watch 'client/**/*.jade', ['jade']
    gulp.watch 'client/**/*.less', ['less']
    gulp.watch 'client/translations/*.yml', ['translations']
    gulp.watch 'vendor', ['vendor']
