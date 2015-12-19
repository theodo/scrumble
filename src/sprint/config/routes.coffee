angular.module 'NotSoShitty.bdc'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.current-sprint',
    url: '/sprint/current'
    controller: 'BurnDownChartCtrl'
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
    url: '/sprint/new'
    controller: 'NewSprintCtrl'
    templateUrl: 'sprint/states/new-sprint/view.html'
    resolve:
      project: (NotSoShittyUser, Project) ->
        NotSoShittyUser.getCurrentUser()
        .then (user) ->
          new Project user.project
        .catch (err) ->
          console.log err
          return null
