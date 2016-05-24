gulp = require 'gulp'

gulp.task 'assets', (done) ->
  gulp.src [
    "#{__dirname}/../src/assets/**/*"
  ]
  .pipe gulp.dest("#{__dirname}/../public")
  .on 'end', done
  return
