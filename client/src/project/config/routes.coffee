angular.module 'Scrumble.settings'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.project',
    url: '/project'
    controller: 'ProjectCtrl'
    templateUrl: 'project/states/main/view.html'
    resolve:
      user: (ScrumbleUser, localStorageService, $state) ->
        ScrumbleUser.getCurrentUser()
      boards: (TrelloClient) ->
        TrelloClient.get('/members/me/boards').then (response) ->
          return response.data
  .state 'tab.team',
    url: '/project/:projectId/team'
    controller: 'TeamCtrl'
    templateUrl: 'project/states/team/view.html'
