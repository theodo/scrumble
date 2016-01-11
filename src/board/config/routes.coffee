angular.module 'NotSoShitty.board'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.board',
    url: '/'
    controller: 'BoardCtrl'
    templateUrl: 'board/states/board/view.html'
    resolve:
      sprint: (NotSoShittyUser, Sprint, $state) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          return $state.go 'trello-login' unless user?
          return $state.go 'tab.project' unless user.project?
          Sprint.getActiveSprint user.project
        .then (sprint) ->
          $state.go 'tab.new-sprint' unless sprint?
          sprint
      project: (NotSoShittyUser, Project, $state) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          return $state.go 'trello-login' unless user?
          return $state.go 'tab.project' unless user.project?
          Project.find user.project.objectId
        .catch (err) ->
          if err.status is 404
            $state.go 'tab.project'
