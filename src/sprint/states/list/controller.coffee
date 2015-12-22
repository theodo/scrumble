angular.module 'NotSoShitty.bdc'
.controller 'SprintListCtrl', (
  $scope
  $mdDialog
  $mdMedia
  sprints
  project
) ->
  sprints.forEach (sprint) ->
    sprint.dates.start = moment(sprint.dates.start).format "MMMM Do YYYY"
    sprint.dates.end = moment(sprint.dates.end).format "MMMM Do YYYY"

  $scope.sprints = sprints
  $scope.project = project

  $scope.selected = []
  $scope.delete = (event) ->
    confirm = $mdDialog.confirm()
    .title 'Delete sprints'
    .textContent 'Are you sure you want to do what you\'re trying to do ?'
    .ariaLabel 'Delete sprints dialog'
    .targetEvent event
    .ok 'Delete'
    .cancel 'Cancel'

    $mdDialog.show(confirm).then ->
      for sprint in $scope.selected
        sprint.destroy().then ->
          _.remove $scope.sprints, sprint
      $scope.selected = []

  BDCDialogController = ($scope, $mdDialog, sprint) ->
    $scope.sprint = sprint
    $scope.cancel = $mdDialog.cancel

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
