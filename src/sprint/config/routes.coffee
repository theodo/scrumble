angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.current-sprint',
    url: '/sprint/current'
    controller: 'CurrentSprintCtrl'
    templateUrl: 'sprint/states/current-sprint/view.html'
    resolve:
      sprint: (NotSoShittyUser, Sprint, $state) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          return $state.go 'trello-login' unless user?
          Sprint.getActiveSprint user.project
        .then (sprint) ->
          $state.go 'tab.new-sprint' unless sprint?
          sprint
      project: (NotSoShittyUser, Project, $state) ->
        return $state.go 'trello-login' unless user?
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          Project.find user.project.objectId
        .catch (err) ->
          if err.status is 404
            $state.go 'tab.project'
  .state 'tab.new-sprint',
    url: '/sprint/edit'
    controller: 'EditSprintCtrl'
    templateUrl: 'sprint/states/edit/view.html'
    resolve:
      project: (NotSoShittyUser, Project) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          new Project user.project
        .catch (err) ->
          console.log err
          return null
      sprint: (NotSoShittyUser, Project, Sprint) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          new Sprint
            project: new Project user.project
            info:
              bdcTitle: 'Burndown Chart'
            number: null
            goal: null
            doneColumn: null
            dates:
              start: null
              end: null
              days: []
            resources:
              matrix: []
              speed: null
              totalPoints: null
            isActive: false

  .state 'tab.edit-sprint',
    url: '/sprint/:sprintId/edit'
    controller: 'EditSprintCtrl'
    templateUrl: 'sprint/states/edit/view.html'
    resolve:
      project: (NotSoShittyUser, Project) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          new Project user.project
        .catch (err) ->
          console.log err
          return null
      sprint: (Sprint, $stateParams, $state) ->
        Sprint.find($stateParams.sprintId).catch (err) ->
          console.warn err
          $state.go 'tab.new-sprint'
  .state 'tab.sprint-list',
    url: '/project/:projectId/sprints'
    controller: 'SprintListCtrl'
    templateUrl: 'sprint/states/list/view.html'
    resolve:
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
      sprints: (Sprint, $stateParams) ->
        Sprint.getByProjectId $stateParams.projectId
