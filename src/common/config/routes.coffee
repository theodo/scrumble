angular.module 'Scrumble.common'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab',
    abstract: true
    templateUrl: 'common/states/base.html'
    controller: 'BaseCtrl'
    resolve:
      sprint: (ScrumbleUser, Sprint) ->
        ScrumbleUser.getCurrentUser()
        .then (user) ->
          return null unless user?.project?
          Sprint.getActiveSprint user.project
        .then (sprint) ->
          return null unless sprint?
          sprint
      project: (ScrumbleUser, Project) ->
        ScrumbleUser.getCurrentUser()
        .then (user) ->
          return null unless user?.project?
          Project.find user.project.objectId
