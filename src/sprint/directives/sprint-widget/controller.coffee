angular.module 'Scrumble.sprint'
.controller 'SprintWidgetCtrl', (
  $scope
  $timeout
  $state
  nssModal
  sprintUtils
  dynamicFields
  bdc
  Project
  Sprint
) ->
  dynamicFields.project $scope.project
  dynamicFields.sprint $scope.sprint

  dynamicFields.render $scope.project?.settings?.bdcTitle
  .then (title) ->
    $scope.bdcTitle = title

  $scope.openEditTitle = (ev) ->
    nssModal.show
      controller: DialogController
      templateUrl: 'sprint/directives/sprint-widget/editBDCTitle.html'
      targetEvent: ev
      resolve:
        title: -> $scope.project.settings?.bdcTitle
        availableFields: -> dynamicFields.getAvailableFields()
    .then (title) ->
      Project.saveTitle($scope.project, title)
      .then (title) ->
        dynamicFields.render title
      .then (title) ->
        $scope.bdcTitle = title

  DialogController = ($scope, $mdDialog, title, availableFields) ->
    $scope.title = title
    $scope.availableFields = availableFields
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.title

  $scope.updateBDC = ->
    bdc.setDonePointsAndSave $scope.sprint
    .then ->
      $scope.$emit 'bdc:update'

  $scope.printBDC = ->
    $state.go 'print-bdc', {
      projectId: $scope.project.objectId,
      sprintId: $scope.sprint.objectId
    }
