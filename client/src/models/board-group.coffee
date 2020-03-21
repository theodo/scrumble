angular.module 'Scrumble.models'
.service 'BoardGroup', ($resource, $q, $http, API_URL) ->
  endpoint = "#{API_URL}/BoardGroups"
  BoardGroups = $resource(
    "#{endpoint}/:id:action",
    {id: '@id'},
    update:
      method: 'PUT'
    mine:
      method: 'GET'
      params:
        action: 'mine'
      isArray: true
    delete:
      method: 'DELETE'
  )

  new: ->
    new BoardGroups()
  addBoard: (group, boardId) ->
    group.$addBoard(boardId)
  delete: (parameters, success, error) ->
    BoardGroups.delete(parameters, success, error).$promise
  mine: ->
    BoardGroups.mine().$promise
    .then (groups) ->
      _.map groups, (group) -> new BoardGroups(group)
  save: (group) ->
    if group.id
      group.$update()
    else
      group.$save()
  getProblems: (groupId) ->
    trelloToken = localStorage.getItem('trello_token')
    $http.get("#{API_URL}/BoardGroups/#{groupId}/problems?trelloToken=#{trelloToken}")
    .then (response) ->
      response.data
