angular.module 'NotSoShitty.settings'
.service 'Computer', ->
  getTotalManDays = (matrix) ->
    total = 0
    for line in matrix
      for cell in line
        total += cell
    total

  calculateTotalPoints = (totalManDays, speed) ->
    totalManDays * speed

  calculateSpeed = (totalPoints, totalManDays) ->
    return unless totalManDays > 0
    totalPoints / totalManDays

  #
  # getCard = (cardId) ->
  #   return unless cardId
  #   $http
  #     method: 'get'
  #     url: TRELLO_SETTING.apiUrl + '/cards/' + cardId
  #     params:
  #       key: TRELLO_SETTING.applicationKey
  #       token: localStorageService.get 'token'
  #   .then (res) ->
  #     res.data
  #
  generateResources = (days, devTeam) ->
    return unless days and devTeam
    matrix = []
    for day in days
      line = []
      for member in devTeam
        line.push 1
      matrix.push line
    matrix
  #
  # getCardsFromColumn = (listId) ->
  #   $http
  #     method: 'get'
  #     url: TRELLO_SETTING.apiUrl + '/lists/' + listId + '/cards'
  #     params:
  #       key: TRELLO_SETTING.applicationKey
  #       token: localStorageService.get 'token'
  #   .then (res) ->
  #     res.data
  #

  # getCardDesc = (cardId) ->
  #   $http
  #     method: 'get'
  #     url: TRELLO_SETTING.apiUrl + '/cards/' + cardId + '/desc'
  #     params:
  #       key: TRELLO_SETTING.applicationKey
  #       token: localStorageService.get 'token'
  #   .then (res) ->
  #     res?.data?._value
  #
  #
  #
  #
  #
  # clearTeam = ->
  #   storage.setup.team.dev = []
  #   storage.setup.team.rest = []
  #
  # clearTeam: clearTeam
  # getBoards: getBoards
  # getBoardColumns: getBoardColumns
  # getBoardMembers: getBoardMembers
  generateResources: generateResources
  calculateSpeed: calculateSpeed
  calculateTotalPoints: calculateTotalPoints
  # getCardsFromColumn: getCardsFromColumn
  # getCard: getCard
  # saveToCard: saveToCard
  getTotalManDays: getTotalManDays
