angular.module 'Scrumble.privacy-policy'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.privacy-policy',
    url: '/privacy-policy'
    controller: 'PrivacyCtrl'
    templateUrl: 'privacy-policy/states/policy/view.html'
