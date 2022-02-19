template = require '../states/list/view.html'

angular.module 'Scrumble.feedback'
.config ['$stateProvider', ($stateProvider) ->
  $stateProvider

  .state 'tab.feedback',
    url: '/feedback'
    controller: 'FeedbackListCtrl'
    template: template
]