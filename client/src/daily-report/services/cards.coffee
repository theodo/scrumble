angular.module 'Scrumble.daily-report'
.service 'trelloCards', (
  $q
  TrelloClient
) ->
  getTodoCards: (project, sprint) ->
    promises = {}

    for column in ['blocked', 'toValidate', 'doing', 'sprint']
      if project?.columnMapping?[column]?
        promises["#{column}Cards"] = TrelloClient.get "/lists/#{project.columnMapping[column]}/cards"
        promises[column] = TrelloClient.get "/lists/#{project.columnMapping[column]}"
    if sprint?.sprintColumn?
      promises['sprintCards'] = TrelloClient.get "/lists/#{sprint.sprintColumn}/cards"
      promises['sprint'] = TrelloClient.get "/lists/#{sprint.sprintColumn}"
    $q.all promises
    .then (responses) ->
      cards = []
      for column in ['sprint', 'doing', 'toValidate', 'blocked' ]
        if responses["#{column}Cards"]?
          for card in responses["#{column}Cards"].data
            card.list = responses["#{column}"].data.name
            cards.push card
      cards

  getDoneCardIds: (doneColumnId) ->
    deferred = $q.defer()
    if doneColumnId?
      TrelloClient.get "/lists/#{doneColumnId}/cards"
      .then (response) ->
        deferred.resolve (card.id for card in response.data)
    else
      deferred.resolve []
    deferred.promise
