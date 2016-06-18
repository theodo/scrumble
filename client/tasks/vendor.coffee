gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

bowerComponentsPath = "#{__dirname}/../bower_components"

gulp.task 'vendor', (done) ->
  gulp.src [
    "#{bowerComponentsPath}/angular/angular.min.js"
    "#{bowerComponentsPath}/angular-resource/angular-resource.min.js"
    "#{bowerComponentsPath}/angular-animate/angular-animate.min.js"
    "#{bowerComponentsPath}/angular-sanitize/angular-sanitize.min.js"
    "#{bowerComponentsPath}/angular-aria/angular-aria.min.js"
    "#{bowerComponentsPath}/angular-permission/dist/angular-permission.js"
    "#{bowerComponentsPath}/angular-messages/angular-messages.min.js"
    "#{bowerComponentsPath}/angular-material/angular-material.min.js"
    "#{bowerComponentsPath}/angular-ui-router/release/angular-ui-router.min.js"
    "#{bowerComponentsPath}/satellizer/satellizer.min.js"
    "#{bowerComponentsPath}/angular-trello-api-client/dist/angular-trello-api-client.js"
    "#{bowerComponentsPath}/angular-local-storage/dist/angular-local-storage.min.js"
    "#{bowerComponentsPath}/moment/moment.js"
    "#{bowerComponentsPath}/lodash/lodash.js"
    "#{bowerComponentsPath}/d3/d3.min.js"
    "#{bowerComponentsPath}/d3-bdc/dist/d3-bdc.js"
    "#{bowerComponentsPath}/c3/c3.min.js"
    "#{bowerComponentsPath}/angular-material-data-table/dist/md-data-table.min.js" # should be included soon in angular-material
    "#{bowerComponentsPath}/MimeJS/dist/mime.js"
    "#{bowerComponentsPath}/showdown/dist/showdown.min.js"
    "#{bowerComponentsPath}/angular-async-loader/dist/angular-async-loader.min.js"
    "#{bowerComponentsPath}/angular-date-interceptor/dist/angular-date-interceptor.min.js"
    "#{bowerComponentsPath}/jquery/dist/jquery.min.js"
    "#{bowerComponentsPath}/angular-trello/dist/angular-trello.min.js"
  ]
  .pipe(concat('vendor.js'))
  .on 'error', gutil.log
  .pipe gulp.dest("#{__dirname}/../public/js")
  .on 'end', done
  return
