angular.module 'Scrumble.board'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.board',
    url: '/'
    controller: 'BoardCtrl'
    templateUrl: 'board/states/board/view.html'
    resolve:
      sprint: (ScrumbleUser, Sprint, $state) ->
        ScrumbleUser.getCurrentUser()
        .then (user) ->
          return $state.go 'trello-login' unless user?
          return $state.go 'tab.project' unless user.project?
          Sprint.getActiveSprint user.project
        .then (sprint) ->
          $state.go 'tab.new-sprint' unless sprint?
          sprint
      project: (ScrumbleUser, Project, $state) ->
        ScrumbleUser.getCurrentUser()
        .then (user) ->
          return $state.go 'trello-login' unless user?
          return $state.go 'tab.project' unless user.project?
          Project.find user.project.objectId
        .catch (err) ->
          if err.status is 404
            $state.go 'tab.project'
