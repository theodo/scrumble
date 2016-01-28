angular.module 'Scrumble.sprint'
.directive 'burndown', ->
  restrict: 'AE'
  scope:
    data: '='
  templateUrl: 'sprint/directives/burndown/view.html'
  controller: ($scope, $timeout) ->
    whRatio = 0.54

    computeDimensions = ->
      chart = document.getElementsByClassName('chart')?[0]
      chart?.parentNode.removeChild chart
      width = document.getElementById('bdcgraph')?.clientWidth - 120
      width = Math.min width, 1000
      height = whRatio * width

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
          standard: '#FF5253'
          done: '#1a69cd'
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

    window.onresize = ->
      config = computeDimensions()
      renderBDC $scope.data, config

    $scope.$watch 'data', (data) ->
      return unless data
      config = computeDimensions()
      renderBDC data, config
    , true

    $timeout ->
      return unless $scope.data
      config = computeDimensions()
      renderBDC $scope.data, config
    , 200
