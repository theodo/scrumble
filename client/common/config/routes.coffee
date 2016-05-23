angular.module 'Scrumble.common'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab',
    abstract: true
    templateUrl: 'common/states/base.html'
    controller: 'BaseCtrl'
    resolve:
      sprint: (Sprint) ->
        Sprint.getActiveSprint().$promise
      project: (Project) ->
        Project.getUserProject().$promise.then (project) ->
          console.log project
          project
