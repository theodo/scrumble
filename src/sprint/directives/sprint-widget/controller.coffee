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
  if $scope.sprint.bdcData?
    # the date is saved as a string so we've to convert it
    for day in $scope.sprint.bdcData
      day.date = moment(day.date).toDate()
  else
    noteInitialized = true
  $scope.sprint.bdcData = sprintUtils.generateBDC $scope.sprint.dates.days, $scope.sprint.resources, $scope.sprint.bdcData

  if noteInitialized
    $timeout ->
      svg = d3.select('#bdcgraph')[0][0].firstChild
      bdc.saveImage $scope.sprint, svg

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
    bdc.setDonePointsAndSave($scope.sprint).then ->
      svg = d3.select('#bdcgraph')[0][0].firstChild
      bdc.saveImage $scope.sprint, svg

  $scope.printBDC = ->
    $state.go 'print-bdc', {
      projectId: $scope.project.objectId,
      sprintId: $scope.sprint.objectId
    }
