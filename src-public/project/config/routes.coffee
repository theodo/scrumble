angular.module 'NotSoShitty.settings'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.project',
    url: '/project'
    controller: 'ProjectCtrl'
    templateUrl: 'project/states/main/view.html'
    resolve:
      user: (NotSoShittyUser) ->
        NotSoShittyUser.getCurrentUser()
      boards: (TrelloClient) ->
        TrelloClient.get('/members/me/boards').then (response) ->
          return response.data
    data:
      permissions:
        only: ['trello-authenticated']
        redirectTo: 'trello-login'
