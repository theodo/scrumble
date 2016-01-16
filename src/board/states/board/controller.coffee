angular.module 'Scrumble.sprint'
.controller 'BoardCtrl', (
  $scope
  $state
  $timeout
  $mdDialog
  sprint
  project
  Sprint
) ->
  $scope.project = project
  $scope.sprint = sprint
