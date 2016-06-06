gulp = require 'gulp'
ngConstant = require 'gulp-ng-constant'

gulp.task 'constant', ->
  ngConstant
    name: 'Scrumble.constants'
    constants:
      API_URL: process.env.API_URL or 'http://localhost:8000/v1'
      GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID or 'TO BE DEFINED'
      TRELLO_KEY: process.env.TRELLO_KEY
    stream: true
  .pipe gulp.dest "#{__dirname}/../src"
