angular.module 'NotSoShitty.settings'
.controller 'ResourcesWidgetCtrl',
($scope, Computer) ->
  $scope.dates?.start = moment($scope.dates?.start).toDate()
  $scope.dates?.end = moment($scope.dates?.end).toDate()

  $scope.clearTeam = ->
    $scope.team.rest = []
    $scope.team.dev = []


  $scope.$watch 'team.dev', (newVal, oldVal) ->
    return if newVal is oldVal
    $scope.resources.matrix = Computer.generateResources $scope.dates?.days, $scope.team?.dev

  
