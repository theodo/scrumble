angular.module 'Scrumble.sprint'
.controller 'SprintWidgetCtrl', (
  $scope
  $mdToast
  $document
  nssModal
  dynamicFields
  bdc
  Project
  Sprint
) ->
  dynamicFieldsPromise = dynamicFields.ready $scope.sprint, $scope.project

  dynamicFieldsPromise
  .then (builtDict) ->
    $scope.bdcTitle = dynamicFields.render $scope.project?.settings?.bdcTitle, builtDict

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
      dynamicFieldsPromise
      .then (builtDict) ->
        $scope.bdcTitle = dynamicFields.render title, builtDict

  DialogController = ($scope, $mdDialog, title, availableFields) ->
    $scope.title = title
    $scope.availableFields = availableFields
    $scope.hide = ->
      $mdDialog.hide()
    $scope.cancel = ->
      $mdDialog.cancel()
    $scope.save = ->
      $mdDialog.hide $scope.title

  $scope.forward = ->
    bdc.setDonePointsAndSave $scope.sprint
    .then ->
      $scope.$emit 'bdc:update'
    .catch (err) ->
      if err is 'DONE_COLUMN_MISSING'
        $mdToast.show(
          $mdToast.simple()
          .textContent('No "done" column select. Edit sprint settings')
          .position('top left')
          .hideDelay(3000)
          .parent($document[0].querySelector 'main')
        )

  $scope.backward = ->
    bdc.removeLastDoneAndSave $scope.sprint
    .then ->
      $scope.$emit 'bdc:update'

  $scope.printBDC = ->
    window.print()
