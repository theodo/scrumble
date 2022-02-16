template = require '../states/policy/view.html'

angular.module 'Scrumble.policy'
.config ($stateProvider) ->
  $stateProvider
  .state 'policy',
    url: '/policy'
    controller: 'PolicyCtrl'
    template: template
