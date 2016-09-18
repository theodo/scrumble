angular.module 'Scrumble.common'
.service 'trelloUtils', (TrelloClient) ->
  getCardPoints = (card) ->
    return 0 unless _.isString card?.name
    match = card.name.match /\(([-+]?[0-9]*\.?[0-9]+)\)/
    value = 0
    if match
      for matchVal in match
        value = parseFloat(matchVal, 10) unless isNaN(parseFloat(matchVal, 10))
    value

  isTrelloCardUrl: (url) ->
    return /trello.com\/c/.test url

  getCardInfoFromUrl: (cardUrl) ->
    shortCode = cardUrl?.match(/\/c\/(.*)\//)?[1]
    return unless shortCode

    TrelloClient.get '/cards/' + shortCode + '?fields=name,idShort'
    .then ({data}) ->
      card =
        number: data?.idShort
        name: data?.name
    .catch (err) ->
      console.warn err
      return

  getColumnPoints: (columnId) ->
    TrelloClient.get '/lists/' + columnId + '/cards?fields=name'
    .then (response) ->
      cards = response.data
      _.sumBy cards, getCardPoints
    .catch (err) ->
      console.warn err
      return 0
