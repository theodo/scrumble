angular.module 'NotSoShitty.gmail-client'
.config ($stateProvider) ->
  $stateProvider
  .state 'gmail-client',
    url: '/gmail-client'
    controller: 'GmailClientCtrl'
    templateUrl: 'gmail-client/states/view.html'
