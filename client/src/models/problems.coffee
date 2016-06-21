angular.module 'Scrumble.models'
.service 'Problem', ($resource, $q, $http, API_URL) ->
  endpoint = "#{API_URL}/Problems"
  Problem = $resource(
    "#{endpoint}/:problemId",
    {problemId: '@id'},
    update:
      method: 'PUT'
  )

  new: ->
    new Problem()
  get: (parameters, success, error) ->
    Organization.get(parameters, success, error).$promise
  query: (parameters, success, error) ->
    Problem.query(parameters, success, error).$promise
  save: (problem) ->
    if problem.id
      problem.$update()
    else
      problem.$save()
