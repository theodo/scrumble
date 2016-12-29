angular.module 'Scrumble.common'
.service 'trelloUtils', (TrelloClient, $q) ->
  getCardPoints = (card) ->
    return 0 unless _.isString card?.name
    match = card.name.match /\(([-+]?[0-9]*\.?[0-9]+)\)/
    value = 0
    if match
      for matchVal in match
        value = parseFloat(matchVal, 10) unless isNaN(parseFloat(matchVal, 10))
    value

  getColorCode = (labelColor) ->
    colors =
      red: '#f44336'
      green: '#61bd4f'
      orange: '#ff9800'
      yellow: '#ffeb3b'
      purple: '#9c27b0'
      blue: '#0079bf'
      sky: '#00c2e0'
      pink: '#ff80ce'
      black: '#4d4d4d'
      lime: '#51e898'
    return colors[labelColor]

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

  getColumnPointsByLabel: (columns) ->
    [
      name: 'cardId'
      data: [0, 0, 3, 0]
    ]
    return $q.when(null) unless columns?
    promises = (TrelloClient.get('/lists/' + column.id + '/cards?fields=idShort,name,labels') for column in columns)
    $q.all(promises)
    .then (responses) ->
      cards = []
      angular.forEach responses, (response, index) ->
        _.forEach response.data, (card) ->
          card.column = columns[index].name
        cards = cards.concat(response.data)

      labels = _.reduce cards, (accumulator, card) ->
        _.concat accumulator, card.labels
      , []
      labels = _.uniqBy(labels, 'id')

      data = _.map cards, (card) ->
        points = getCardPoints(card)
        name: card.idShort
        data: _.map labels, (label) ->
          if label.name in _.map card.labels, 'name'
            console.log label.name, label.color, getColorCode(label.color)
            color: getColorCode(label.color)
            y: points
            name: card.idShort
            description: card.name
            list: card.column
          else
            null
      labels: _.map labels, 'name'
      data: data

    .catch (err) ->
      console.warn err
      return 0

  getListIdsAndNames: (boardId) ->
    TrelloClient.get "/boards/#{boardId}/lists?fields=id,name"
    .then (response) ->
      response.data
