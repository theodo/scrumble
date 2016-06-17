angular.module 'Scrumble.models'
.service 'Organization', ($resource, $q, $http, TrelloClient, API_URL) ->
  endpoint = "#{API_URL}/Organizations"
  Organization = $resource(
    "#{endpoint}/:organizationId",
    {organizationId: '@id'},
    update:
      method: 'PUT'
  )

  findOrCreate = (remoteId) ->
    return $q.when(null) unless remoteId?
    Organization.query
      filter:
        where:
          remoteId: remoteId
    .$promise.then (organizations) ->
      return organizations[0].id if organizations.length > 0
      console.log('before')
      TrelloClient.get "/organizations/#{remoteId}"
      .then (response) ->
        console.log('response')
        Organization.save
          remoteId: response.data?.id
          name: response.data?.displayName
        .$promise.then (organization) ->
          organization.id
      .catch (error) ->
        console.log('catch')
        return null

  new: ->
    new Organization()
  get: (parameters, success, error) ->
    Organization.get(parameters, success, error).$promise
  update: Organization.update
  findOrCreate: findOrCreate
