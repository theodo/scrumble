angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.current-sprint',
    url: '/sprint/current'
    controller: 'CurrentSprintCtrl'
    templateUrl: 'sprint/states/current-sprint/view.html'
    resolve:
      sprint: (NotSoShittyUser, Sprint) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          Sprint.getActiveSprint user.project
        .catch (err) ->
          console.log err
          return null
      project: (NotSoShittyUser, Project) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          Project.find user.project.objectId
        .then (project) ->
          project
        .catch (err) ->
          console.log err
          return null
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
            info =
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
