angular.module 'Scrumble.sprint'
.controller 'SprintDetailsCtrl', ['$scope', '$state', '$mdMedia', '$mdDialog', 'Sprint', 'loadingToast', (
  $scope
  $state
  $mdMedia
  $mdDialog
  Sprint
  loadingToast
) ->
  $scope.showBurndown = (ev, sprint) ->
    useFullScreen = $mdMedia('sm') or $mdMedia('xs')
    $mdDialog.show
      controller: ['$scope', '$mdDialog', 'sprint', 'bdc', '$timeout', BDCDialogController]
      template: require('../states/list/bdc.dialog.html')
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      resolve:
        sprint: -> sprint
      fullscreen: useFullScreen

  $scope.activateSprint = (sprint) ->
    Sprint.activate(sprint.id).then ->
      $scope.$emit 'sprint:update'

  $scope.delete = (sprint, event) ->
    confirm = $mdDialog.confirm()
    .title 'Delete sprints'
    .textContent 'Are you sure you want to do what you\'re trying to do ?'
    .ariaLabel 'Delete sprints dialog'
    .targetEvent event
    .ok 'Delete'
    .cancel 'Cancel'

    $mdDialog.show(confirm).then ->
      loadingToast.show 'deleting'
      Sprint.delete($scope.sprint.id).then ->
        _.remove $scope.sprints, sprint
        loadingToast.hide 'deleting'

  $scope.indicators = (sprint) ->
    $state.go 'tab.indicators', {sprintId: sprint.id}

  BDCDialogController = ($scope, $mdDialog, sprint, bdc, $timeout) ->
    $scope.sprint = sprint
    $scope.cancel = $mdDialog.cancel

    $timeout ->
      svg = d3.select('#bdcgraph')[0][0].firstChild
      bdc.getPngBase64(svg)
      .then (pngBase64) ->
        $scope.pngBase64 = pngBase64

]