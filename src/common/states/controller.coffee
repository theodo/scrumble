angular.module 'NotSoShitty.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $state
  Avatar
  localStorageService
) ->

  $scope.toggleSidenav = (menuId) ->
    $mdSidenav(menuId).toggle()

  $scope.close = (menuId) ->
    $mdSidenav(menuId).close()

  $scope.email = localStorageService.get('trello_email')

  $scope.project = ->
    $state.go 'tab.project'
    $scope.close('left')

  $scope.sprint = ->
    $state.go 'tab.current-sprint'
    $scope.close('left')

  $scope.dailyReport = ->
    $state.go 'tab.daily-report'
    $scope.close('left')
