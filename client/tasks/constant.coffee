gulp = require 'gulp'
ngConstant = require 'gulp-ng-constant'

gulp.task 'constant', ->
  console.log process.env
  ngConstant
    name: 'Scrumble.constants'
    constants:
      API_URL: process.env.API_URL or 'http://0.0.0.0:8000/v1'
      GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID or 'TO BE DEFINED'
      TRELLO_KEY: process.env.API_ENV_TRELLO_KEY
    stream: true
  .pipe gulp.dest "#{__dirname}/../src"
