angular.module 'NotSoShitty.menu'
.controller 'DialogCtrl', (
  $scope
  $mdDialog
  ) ->

  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.answer = (answer) ->
    $mdDialog.hide answer
    return

  return
