less = require 'gulp-less'
concat = require 'gulp-concat'

gulp.task 'less', (done) ->
  gulp.src "#{__dirname}/../src/**/*.less"
  .pipe less()
  .pipe concat 'app.css'
  .pipe gulp.dest "#{__dirname}/../public/css"
  .on 'end', done
  return
