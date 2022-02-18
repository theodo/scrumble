angular.module 'Scrumble.organization'
.controller 'OrganizationProblemsCtrl', ['$scope', '$stateParams', 'Organization', (
  $scope
  $stateParams
  Organization
) ->
  $scope.organizationId = $stateParams.organizationId

  Organization.get(organizationId: $stateParams.organizationId)
  .then (organization) ->
    $scope.organization = organization
]