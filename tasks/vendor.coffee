gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

gulp.task 'vendor', (done) ->
  gulp.src [
    'bower_components/angular/angular.min.js'
    'bower_components/angular-resource/angular-resource.min.js'
    'bower_components/angular-animate/angular-animate.min.js'
    'bower_components/angular-sanitize/angular-sanitize.min.js'
    'bower_components/angular-aria/angular-aria.min.js'
    'bower_components/angular-permission/dist/angular-permission.js'
    'bower_components/angular-material/angular-material.min.js'
    'bower_components/angular-ui-router/release/angular-ui-router.min.js'
    'bower_components/angular-parse/angular-parse.js'
    'bower_components/satellizer/satellizer.min.js'
    'bower_components/angular-trello-api-client/dist/angular-trello-api-client.js'
    'bower_components/angular-local-storage/dist/angular-local-storage.min.js'
    'bower_components/moment/moment.js'
    'bower_components/lodash/lodash.js'
    'bower_components/d3/d3.min.js'
    'bower_components/d3-bdc/dist/d3-bdc.js'
    'bower_components/angular-material-data-table/dist/md-data-table.min.js' # should be included soon in angular-material
    'bower_components/angular-google-gapi/angular-google-gapi.min.js'
    'bower_components/MimeJS/dist/mime.js'
    'bower_components/showdown/dist/showdown.min.js'
  ]
  .pipe(concat('vendor.js'))
  .on 'error', gutil.log
  .pipe gulp.dest('public/js')
  .on 'end', done
  return
