angular.module 'Scrumble.sprint'
.config ($stateProvider) ->
  $stateProvider

  .state 'tab.new-sprint',
    url: '/project/:projectId/sprint'
    controller: 'EditSprintCtrl'
    templateUrl: 'sprint/states/edit/view.html'
    resolve:
      sprint: ($stateParams, Sprint) ->
        Sprint.new($stateParams.projectId)

  .state 'tab.edit-sprint',
    url: '/sprint/:sprintId/edit'
    controller: 'EditSprintCtrl'
    templateUrl: 'sprint/states/edit/view.html'
    resolve:
      sprint: ($stateParams, Sprint, $state) ->
        Sprint.get(sprintId: $stateParams.sprintId)
        .catch (err) ->
          $state.go('tab.new-sprint')

  .state 'tab.sprint-list',
    url: '/project/:projectId/sprints'
    controller: 'SprintListCtrl'
    templateUrl: 'sprint/states/list/view.html'
    resolve:
      project: (Project, $stateParams) ->
        Project.get(
          projectId: $stateParams.projectId
          filter:
            include:
              relation: 'sprints'
              scope:
                order: 'number DESC'
        )
