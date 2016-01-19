angular.module 'Scrumble.sprint'
.controller 'PrintBDCCtrl', (
  $scope
  $timeout
  sprint
  project
) ->
  $scope.project = project
  $scope.sprint = sprint
  $timeout ->
    window.print()
  , 500
