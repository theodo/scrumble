angular.module 'NotSoShitty.common'
.service 'trelloUtils', (TrelloClient) ->
  getCardPoints = (card) ->
    return unless card.name
    match = card.name.match /\(([-+]?[0-9]*\.?[0-9]+)\)/
    value = 0
    if match
      for matchVal in match
        value = parseFloat(matchVal, 10) unless isNaN(parseFloat(matchVal, 10))
    value

  getColumnPoints: (columnId) ->
    TrelloClient.get '/lists/' + columnId + '/cards?fields=name'
    .then (response) ->
      cards = response.data
      _.sum cards, getCardPoints
    .catch (err) ->
      console.warn err
      return 0
