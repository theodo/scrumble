angular.module 'Scrumble.organization'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.organization',
    url: '/organization/:organizationId'
    controller: 'OrganizationCtrl'
    templateUrl: 'organization/states/settings/view.html'
