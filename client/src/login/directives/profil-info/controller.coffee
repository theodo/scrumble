angular.module 'Scrumble.login'
.controller 'ProfilInfoCtrl', ['$scope', '$timeout', '$rootScope', 'trelloAuth', 'googleAuth', (
  $scope
  $timeout
  $rootScope
  trelloAuth
  googleAuth
) ->
  $scope.googleUser =
    picture: "images/default-profile.jpg"
  $scope.openMenu = ($mdOpenMenu, ev) ->
    originatorEv = ev
    $mdOpenMenu ev

  $scope.logout = trelloAuth.logout

  getTrelloInfo = ->
    trelloAuth.getTrelloInfo().then (user) ->
      $scope.userInfo = user

  getTrelloInfo()

  if googleAuth.isAuthenticated()
    googleAuth.getUserInfo().then (user) ->
      $scope.googleUser = user

  $scope.googleLogin = ->
    googleAuth.login().then ->
      googleAuth.getUserInfo().then (user) ->
        $scope.googleUser = user
  $scope.googleLogout = ->
    $scope.googleUser = null
    $scope.googleUser =
      picture: "images/default-profile.jpg"
    googleAuth.logout()

]