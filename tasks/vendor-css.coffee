gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

gulp.task 'vendor-css', (done) ->
  gulp.src [
    'bower_components/angular-material/angular-material.min.css'
    'bower_components/angular-material-data-table/dist/md-data-table.min.css'
    'bower_components/mdi/css/materialdesignicons.min.css'
  ]
  .pipe(concat('vendor.css'))
  .on 'error', gutil.log
  .pipe gulp.dest('public/css')
  .on 'end', done
  return
