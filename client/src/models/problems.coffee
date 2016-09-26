angular.module 'Scrumble.models'
.service 'Problem', ($resource, $q, $http, Project, API_URL, trelloUtils) ->
  endpoint = "#{API_URL}/Problems"
  Problem = $resource(
    "#{endpoint}/:problemId",
    {problemId: '@id'},
    update:
      method: 'PUT'
    delete:
      method: 'DELETE'
  )

  new: ->
    new Problem()
  get: (parameters, success, error) ->
    Organization.get(parameters, success, error).$promise
  query: (parameters, success, error) ->
    Problem.query(parameters, success, error).$promise
  delete: (parameters, success, error) ->
    Problem.delete(parameters, success, error).$promise
  save: (problem) ->
    if problem.id
      problem.$update()
    else
      problem.$save()
  getWithOwnerAndCard: ({projectId}) ->
    $q.all [
      Project.get
        projectId: projectId
      Problem.query(
        filter:
          where:
            projectId: projectId
          order: 'happenedDate DESC'
          include: 'tags'
      ).$promise
    ]
    .then ([project, problems]) ->
      _.map problems, (problem) ->
        problem.owner = _.find project.team, (member) ->
          member.id is problem.ownerId
        if trelloUtils.isTrelloCardUrl problem.link
          trelloUtils.getCardInfoFromUrl problem.link
          .then (info) ->
            problem.card = info
        problem
