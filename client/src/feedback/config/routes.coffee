angular.module 'Scrumble.feedback'
.config ($stateProvider) ->
  $stateProvider

  .state 'tab.feedback',
    url: '/feedback'
    controller: 'FeedbackListCtrl'
    templateUrl: 'feedback/states/list/view.html'
