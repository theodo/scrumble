angular.module 'Scrumble.common'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab',
    abstract: true
    templateUrl: 'common/states/base.html'
    controller: 'BaseCtrl'
    resolve:
      sprint: ($state, Sprint) ->
        Sprint.getActiveSprint().$promise.catch (err) -> return
      project: ($state, Project) ->
        Project.getUserProject().catch (err) -> return
