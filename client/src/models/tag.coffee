angular.module 'Scrumble.models'
.service 'Tag', ($resource, $q, $http) ->
  endpoint = "#{API_URL}/Tags"
  Tag = $resource(
    "#{endpoint}/:tagId",
    {tagId: '@id'},
    findOrCreate:
      method: 'PUT'
  )

  new: ->
    new Tag()
  findOrCreate: (tag) ->
    tag.$findOrCreate()
  query: (parameters, success, error) ->
    Tag.query(parameters, success, error).$promise
