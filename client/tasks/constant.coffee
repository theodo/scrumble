gulp = require 'gulp'
ngConstant = require 'gulp-ng-constant'

gulp.task 'constant', ->
  ngConstant
    name: 'Scrumble.constants'
    constants:
      API_URL: process.env.API_URL or 'http://localhost:8000/v1'
    stream: true
  .pipe gulp.dest "#{__dirname}/../src"
