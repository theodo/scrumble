angular.module 'Scrumble.sprint'
.controller 'SprintDetailsCtrl', (
  $scope
  $state
  $mdMedia
  $mdDialog
  Sprint
) ->
  $scope.showBurndown = (ev, sprint) ->
    useFullScreen = $mdMedia('sm') or $mdMedia('xs')
    $mdDialog.show
      controller: BDCDialogController
      templateUrl: 'sprint/states/list/bdc.dialog.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      resolve:
        sprint: -> sprint
      fullscreen: useFullScreen

  $scope.activateSprint = (sprint) ->
    for s in $scope.sprints
      if s.isActive and s != sprint
        Sprint.deactivateSprint s
    Sprint.setActiveSprint(sprint).then ->
      $scope.$emit 'sprint:update'

  $scope.delete = (event) ->
    confirm = $mdDialog.confirm()
    .title 'Delete sprints'
    .textContent 'Are you sure you want to do what you\'re trying to do ?'
    .ariaLabel 'Delete sprints dialog'
    .targetEvent event
    .ok 'Delete'
    .cancel 'Cancel'

    $mdDialog.show(confirm).then ->
      sprint.destroy().then ->
        _.remove $scope.sprints, sprint

  $scope.indicators = ->
    $state.go 'tab.indicators', {sprintId: sprint.objectId}

  BDCDialogController = ($scope, $mdDialog, sprint) ->
    $scope.sprint = sprint
    $scope.cancel = $mdDialog.cancel
