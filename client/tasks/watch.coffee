gulp = require 'gulp'
webserver = require 'gulp-webserver'
runSequence = require 'run-sequence'

gulp.task 'webserver', ['build'], ->
  gulp.src "#{__dirname}/../public"
  .pipe webserver
    livereload: true
    fallback: 'index.html'
    host: '0.0.0.0'
    port: process.env.APP_PORT or 8008

gulp.task 'watch', ->
  runSequence 'webserver', ->
    gulp.watch "#{__dirname}/../src/assets/**/*", ['assets']
    gulp.watch "#{__dirname}/../src/**/*.coffee", ['coffee-public']
    gulp.watch "#{__dirname}/../src/index.jade", ['jade-index']
    gulp.watch "#{__dirname}/../src/**/*.jade", ['jade']
    gulp.watch "#{__dirname}/../src/**/*.less", ['less']
    gulp.watch "#{__dirname}/../src/translations/*.yml", ['translations']
    gulp.watch 'vendor', ['vendor']
