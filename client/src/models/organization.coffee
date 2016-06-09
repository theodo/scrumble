angular.module 'Scrumble.models'
.service 'Organization', ($resource, $http, API_URL) ->
  endpoint = "#{API_URL}/Organizations"
  Organization = $resource(
    "#{endpoint}/:organizationId",
    {organizationId: '@id'},
    update:
      method: 'PUT'
  )

  new: ->
    new Organization()
  get: (parameters, success, error) ->
    Organization.get(parameters, success, error).$promise
  update: Organization.update
