templateSettings = require '../states/settings/view.html'
templateProblems = require '../states/problems/view.html'

angular.module 'Scrumble.organization'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.organization',
    url: '/organization/:organizationId'
    controller: 'OrganizationCtrl'
    template: templateSettings

  .state 'tab.organization-problems',
    url: '/organization/:organizationId/problems'
    controller: 'OrganizationProblemsCtrl'
    template: templateProblems
