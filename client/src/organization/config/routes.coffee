angular.module 'Scrumble.organization'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.organization',
    url: '/organization/:organizationId'
    controller: 'OrganizationCtrl'
    templateUrl: 'organization/states/settings/view.html'

  .state 'tab.organization-problems',
    url: '/organization/:organizationId/problems'
    controller: 'OrganizationProblemsCtrl'
    templateUrl: 'organization/states/problems/view.html'
