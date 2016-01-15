angular.module 'Scrumble.sprint'
.directive 'burndown', ->
  restrict: 'AE'
  scope:
    data: '='
  templateUrl: 'sprint/directives/burndown/view.html'
  link: (scope, elem, attr) ->
    maxWidth = 1000
    whRatio = 0.54

    computeDimensions = ->
      if window.innerWidth > maxWidth
        width = 800
      else
        width = window.innerWidth * 0.8
      height = whRatio * width
      if height + 128 > window.innerHeight
        height = window.innerHeight * 0.8
        width = height / whRatio
      config =
        containerId: '#bdcgraph'
        width: width
        height: height
        margins:
          top: 30
          right: 70
          bottom: 60
          left: 50
        colors:
          standard: '#D93F8E'
          done: '#5AA6CB'
          good: '#97D17A'
          bad: '#FA6E69'
          labels: '#113F59'
        startLabel: 'Start'
        endLabel: 'Ceremony'
        dateFormat: '%A'
        xTitle: ''
        dotRadius: 4
        standardStrokeWidth: 2
        doneStrokeWidth: 2
        goodSuffix: ' :)'
        badSuffix: ' :('
      config

    config = computeDimensions()

    window.onresize = ->
      config = computeDimensions()
      renderBDC scope.data, config

    scope.$watch 'data', (data) ->
      return unless data
      renderBDC data, config
    , true
