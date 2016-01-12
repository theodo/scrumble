angular.module 'NotSoShitty.common'
.controller 'ModalCtrl', ($scope, $mdDialog) ->
  $scope.hide = ->
    $mdDialog.hide()
  $scope.cancel = ->
    $mdDialog.cancel()
  $scope.save = (response) ->
    $mdDialog.hide response
