angular.module 'NotSoShitty.login'
.controller 'GoogleLoginCtrl', ($scope, GAuth) ->
  $scope.authenticate = ->
    GAuth.login().then ->
      console.log 'authenticated!'
    , ->
      console.log 'login fail'
