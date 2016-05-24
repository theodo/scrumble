gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

gulp.task 'vendor-css', (done) ->
  gulp.src [
    "#{__dirname}/../bower_components/angular-material/angular-material.min.css"
    "#{__dirname}/../bower_components/angular-material-data-table/dist/md-data-table.min.css"
    "#{__dirname}/../bower_components/mdi/css/materialdesignicons.min.css"
    "#{__dirname}/../bower_components/c3/c3.min.css"
  ]
  .pipe(concat('vendor.css'))
  .on 'error', gutil.log
  .pipe gulp.dest("#{__dirname}/../public/css")
  .on 'end', done
  return
