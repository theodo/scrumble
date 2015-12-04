angular.module 'NotSoShitty.login'
.controller 'ProfilInfoCtrl', ($rootScope, $scope, $auth, User, $state) ->
  $scope.logout = ->
    $auth.logout()
    $scope.userInfo = null
    $state.go 'login'
    $scope.showProfilCard = false

  getTrelloInfo = ->
    if $auth.isAuthenticated()
      User.getTrelloInfo().then (info) ->
        $scope.userInfo = info
  getTrelloInfo()
  $rootScope.$on 'refresh-profil', getTrelloInfo
  $scope.showProfilCard = false
  $scope.toggleProfilCard = ->
    $scope.showProfilCard = !$scope.showProfilCard
