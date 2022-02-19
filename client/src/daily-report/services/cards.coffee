angular.module 'Scrumble.daily-report'
.service 'trelloCards', ['$q', 'TrelloClient', (
  $q
  TrelloClient
) ->
  getTodoCards: (project, sprint) ->
    promises = {}

    for column in ['blocked', 'toValidate', 'sprint']
      if project?.columnMapping?[column]?
        promises["#{column}Cards"] = TrelloClient.get "/lists/#{project.columnMapping[column]}/cards"
        promises[column] = TrelloClient.get "/lists/#{project.columnMapping[column]}"
    if project?.columnMapping?.doing?
        for column in project.columnMapping.doing
          promises["doing-#{column}Cards"] = TrelloClient.get "/lists/#{column}/cards"
          promises["doing-#{column}"] = TrelloClient.get "/lists/#{column}"
    if sprint?.sprintColumn?
      promises['sprintCards'] = TrelloClient.get "/lists/#{sprint.sprintColumn}/cards"
      promises['sprint'] = TrelloClient.get "/lists/#{sprint.sprintColumn}"
    $q.all promises
    .then (responses) ->
      cards = []
      for column in ['sprint', 'toValidate', 'blocked' ]
        if responses["#{column}Cards"]?
          for card in responses["#{column}Cards"].data
            card.list = responses["#{column}"].data.name
            cards.push card
      if project?.columnMapping?.doing?
        for column in project.columnMapping.doing
          if responses["doing-#{column}Cards"]?
            for card in responses["doing-#{column}Cards"].data
              card.list = responses["doing-#{column}"].data.name
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
]