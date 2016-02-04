angular.module 'Scrumble.indicators'
.controller 'ChecklistCtrl', (
  $scope
  loadingToast
) ->
  $scope.indicators ?= angular.copy $scope.company
  
  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.onSave({$indicators: $scope.indicators})
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.print = ->
    window.print()
