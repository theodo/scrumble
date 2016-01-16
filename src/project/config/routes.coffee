angular.module 'Scrumble.settings'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.project',
    url: '/project'
    controller: 'ProjectCtrl'
    templateUrl: 'project/states/main/view.html'
    resolve:
      user: (ScrumbleUser, localStorageService, $state) ->
        ScrumbleUser.getCurrentUser().then (user) ->
          unless user?
            localStorageService.clearAll()
            console.log 'tab.project:user -> trello-login'
            $state.go 'trello-login'
          user
      boards: (TrelloClient) ->
        TrelloClient.get('/members/me/boards').then (response) ->
          return response.data
