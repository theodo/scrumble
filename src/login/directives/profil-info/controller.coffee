angular.module 'NotSoShitty.login'
.controller 'ProfilInfoCtrl', (
  $scope
  TrelloClient
) ->
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  $scope.logout = ->
    $auth.logout()
    $scope.userInfo = null
    $state.go 'trello-login'
    $scope.showProfilCard = false

  getTrelloInfo = ->
    TrelloClient.get('/member/me').then (response) ->
      console.log response.data
      $scope.userInfo = response.data
  getTrelloInfo()
  $scope.showProfilCard = false
  $scope.toggleProfilCard = ->
    $scope.showProfilCard = !$scope.showProfilCard
