angular.module 'NotSoShitty.daily-report'
.service 'trelloCards', (
  $q
  TrelloClient
) ->
  getTodoCards: (project) ->
    promises = []
    if project?.columnMapping?.blocked?
      promises.push TrelloClient.get "/lists/#{project.columnMapping.blocked}/cards"
    if project?.columnMapping?.toValidate?
      promises.push TrelloClient.get "/lists/#{project.columnMapping.toValidate}/cards"
    if project?.columnMapping?.doing?
      promises.push TrelloClient.get "/lists/#{project.columnMapping.doing}/cards"
    if project?.columnMapping?.sprint?
      promises.push TrelloClient.get "/lists/#{project.columnMapping.sprint}/cards"
    $q.all promises
    .then (responses) ->
      _.flatten (response.data for response in responses)

  getDoneCardIds: (doneColumnId) ->
    deferred = $q.defer()
    if doneColumnId?
      TrelloClient.get "/lists/#{doneColumnId}/cards"
      .then (response) ->
        deferred.resolve (card.id for card in response.data)
    else
      deferred.resolve []
    deferred.promise
