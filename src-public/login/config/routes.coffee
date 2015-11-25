angular.module 'NotSoShitty.login'
.config ($stateProvider) ->
  $stateProvider
  .state 'login',
    url: '/login'
    controller: 'LoginCtrl'
    templateUrl: 'login/states/login/view.html'
