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

      TrelloClient.get "/organizations/#{remoteId}"
      .then (response) ->
        Organization.save
          remoteId: response.data?.id
          name: response.data?.displayName
        .$promise.then (organization) ->
          organization.id

  new: ->
    new Organization()
  get: (parameters, success, error) ->
    Organization.get(parameters, success, error).$promise
  update: Organization.update
  findOrCreate: findOrCreate
  migration: (project) ->
    console.debug 'start project organization migration'
    return if project.organizationId?
    console.debug 'project has no organization set'
    TrelloClient.get "/boards/#{project.boardId}"
    .then (response) ->
      console.debug 'just got trello board'
      return unless response.data?.idOrganization?
      console.debug 'trello board has an organization id'
      findOrCreate(response.data?.idOrganization).then (id) ->
        console.debug 'local organization found or create. id is', id
        project.organizationId = id
        console.debug 'saving project with organization id'
        project.$update()
