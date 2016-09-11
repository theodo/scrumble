angular.module 'Scrumble.lab'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.lab',
    url: '/lab'
    templateUrl: 'lab/states/list/view.html'
  .state 'tab.lab-tags',
    url: '/lab/tags-tracking'
    templateUrl: 'lab/states/tags-tracking/view.html'
    controller: 'TagsTrackingCtrl'
