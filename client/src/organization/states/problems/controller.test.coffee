describe '[controller] OrganizationProblemsCtrl', ->
  beforeEach module 'Scrumble.organization'

  $stateParams = null
  $controller = null
  $q = null
  Organization = null

  beforeEach inject (_Organization_, _$stateParams_, _$controller_, _$q_) ->
    Organization = _Organization_
    $stateParams = _$stateParams_
    $controller = _$controller_
    $q = _$q_

  it 'should call Organization.get with stateParams organization', ->
    spyOn(Organization, 'get').and.returnValue $q.resolve({})
    controller = $controller 'OrganizationProblemsCtrl',
      $scope: {}
      Organization: Organization
      $stateParams:
        organizationId: 1
    expect(Organization.get).toHaveBeenCalledWith organizationId: 1
