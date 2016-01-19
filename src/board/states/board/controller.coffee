angular.module 'Scrumble.sprint'
.controller 'BoardCtrl', (
  $scope
  $rootScope
  $state
  $timeout
  $mdDialog
  sprint
  project
  Sprint
) ->
  $scope.project = project
  $scope.sprint = sprint

  $rootScope.$emit 'currentProjectAndSprint', project

  $scope.showConfirmNewSprint = (ev) ->
    confirm = $mdDialog.confirm()
      .title 'Start a new sprint'
      .textContent 'Starting a new sprint will end this one'
      .targetEvent ev
      .ok 'OK'
      .cancel 'Cancel'
    $mdDialog.show(confirm).then ->
      Sprint.close($scope.sprint).then ->
        $state.go 'tab.new-sprint'

  #To manage Speed dial button
  $scope.menuIsOpen = false
  $scope.tooltipVisible = false
  # On opening, add a delayed property which shows tooltips after the speed dial has opened
  # so that they have the proper position; if closing, immediately hide the tooltips
  $scope.$watch 'menuIsOpen', (isOpen) ->
    if isOpen?
      $timeout ->
        $scope.tooltipVisible = $scope.menuIsOpen
      , 600
    else
      $scope.tooltipVisible = $scope.menuIsOpen
