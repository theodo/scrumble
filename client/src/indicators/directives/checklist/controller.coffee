angular.module 'Scrumble.indicators'
.controller 'ChecklistCtrl', ['$scope', 'loadingToast', 'Sprint', (
  $scope
  loadingToast
  Sprint
) ->
  if _.isArray $scope.sprint?.indicators?.checklists
    for checklist, i in $scope.sprint.indicators.checklists
      for check, j in checklist.list
        $scope.template[i].list[j].selected = check.selected

  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators ?= {}
    $scope.sprint.indicators.checklists = $scope.template
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.print = ->
    window.print()

]