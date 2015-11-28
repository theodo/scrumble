angular.module 'NotSoShitty.settings'
.config ($stateProvider) ->
  $stateProvider
  .state 'settings',
    url: '/settings'
    controller: 'SettingsCtrl'
    templateUrl: 'settings/states/main/view.html'
    resolve:
      settings: (UserBoardStorage, SettingsStorage) ->
        UserBoardStorage.getBoardId().then (boardId) ->
          return null unless boardId?
          SettingsStorage.get(boardId).then (settings) ->
            console.log settings
            return settings
      boards: (TrelloClient) ->
        TrelloClient.get('/members/me/boards').then (response) ->
          return response.data
