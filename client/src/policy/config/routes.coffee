angular.module 'Scrumble.policy'
.config ($stateProvider) ->
  $stateProvider
  .state 'policy',
    url: '/policy'
    controller: 'PolicyCtrl'
    templateUrl: 'policy/states/policy/view.html'
