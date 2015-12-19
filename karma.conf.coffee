module.exports = (config) ->
  config.set
    frameworks: ['jasmine']
    files: [
      'public/js/vendor.js'
      'node_modules/angular-mocks/angular-mocks.js'
      'public/js/templates.js'
      'src/{,**/}module.coffee'
      'src/{,**/}*.coffee'
    ]
    exclude: []
    preprocessors:
      '**/*.coffee': ['coffee']
      '**/!(*test).coffee': ['coverage']
    coverageReporter:
      dir: '../coverage'
      reporters: [
        type: 'html'
        subdir: 'client-report'
      ,
        type: 'text-summary'
      ]
      watermarks:
        statements: [70, 80]
        functions: [70, 80]
        branches: [70, 80]
        lines: [70, 80]
    reporters: [ 'progress' , 'coverage' ]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [ 'PhantomJS' ]
    singleRun: process.env.SINGLE_RUN || true
  return
