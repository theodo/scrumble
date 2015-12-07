angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'burn-down-chart',
    url: '/burn-down-chart'
    controller: 'BurnDownChartCtrl'
    templateUrl: 'burn-down-chart/states/bdc/view.html'
    resolve:
      settings: (UserBoardStorage, SettingsStorage) ->
        UserBoardStorage.getBoardId()
        .then (boardId) ->
          SettingsStorage.get(boardId)
        # .then (response) ->
        #   response.data
        .catch (err) ->
          return null
      doneCards: (UserBoardStorage, SettingsStorage, TrelloClient) ->
        UserBoardStorage.getBoardId()
        .then (boardId) ->
          SettingsStorage.get(boardId)
        .then (response) ->
          response.data
        .then (settings) ->
          TrelloClient.get '/lists/' + settings.columnIds.done + '/cards?fields=name'
        .then (response) ->
          response.data
        .catch (err) ->
          return null
  .state 'new-sprint',
    url: '/sprint/new'
    controller: 'NewSprintCtrl'
    templateUrl: 'burn-down-chart/states/new-sprint/view.html'
    resolve:
      boardId: (UserBoardStorage) ->
        UserBoardStorage.getBoardId()
