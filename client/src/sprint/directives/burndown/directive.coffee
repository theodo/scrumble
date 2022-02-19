angular.module 'Scrumble.sprint'
.directive 'burndown', ->
  restrict: 'AE'
  scope:
    data: '='
  template: '<div id="bdcgraph"></div>'
  controller: ['$scope', '$timeout', '$mdMedia', ($scope, $timeout, $mdMedia) ->
    whRatio = 0.54

    computeDimensions = ->
      chart = document.getElementsByClassName('chart')?[0]
      chart?.parentNode.removeChild chart

      if $mdMedia('sm') or $mdMedia('xs')
        width = document.getElementById('bdcgraph')?.clientWidth
        width = Math.min width, 1000
        height = whRatio * width
        margins =
          top: 30
          right: 0
          bottom: 60
          left: 0
        yScaleOrient = 'right'
        dotRadius = 2
        standardStrokeWidth = 1
        doneStrokeWidth = 1
      else
        width = document.getElementById('bdcgraph')?.clientWidth - 120
        width = Math.min width, 1000
        height = whRatio * width
        margins =
          top: 30
          right: 70
          bottom: 60
          left: 50
        yScaleOrient = 'left'
        dotRadius = 4
        standardStrokeWidth = 2
        doneStrokeWidth = 2
      config =
        containerId: '#bdcgraph'
        width: width
        height: height
        margins: margins
        yScaleOrient: yScaleOrient
        colors:
          standard: '#FF5253'
          done: '#1a69cd'
          good: '#1a69cd'
          bad: '#1a69cd'
          labels: '#113F59'
        startLabel: 'Start'
        endLabel: 'Ceremony'
        dateFormat: '%A %d/%m'
        shortDateFormat: '%d/%m'
        xTitle: ''
        dotRadius: dotRadius
        standardStrokeWidth: standardStrokeWidth
        doneStrokeWidth: doneStrokeWidth
        goodSuffix: ''
        badSuffix: ''
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
  ]