angular.module 'NotSoShitty.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $state
  Avatar
) ->

  $scope.toggleSidenav = (menuId) ->
    $mdSidenav(menuId).toggle()
    console.log 'Ouvrir le menu'

  $scope.close = (menuId) ->
    $mdSidenav(menuId).close()
    console.log 'Fermer le menu'

  $scope.member = Avatar.getMember('nicolasb@theodo.fr')

  $scope.project = ->
    $state.go 'tab.project'
    $scope.close('left')

  $scope.sprint = ->
    $state.go 'tab.current-sprint'
    $scope.close('left')

  $scope.dailyReport = ->
    $state.go 'tab.daily-report'
    $scope.close('left')
