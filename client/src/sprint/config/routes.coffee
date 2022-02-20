angular.module 'Scrumble.sprint'
.config ['$stateProvider', ($stateProvider) ->
  $stateProvider

  .state 'tab.new-sprint',
    url: '/project/:projectId/sprint'
    controller: 'EditSprintCtrl'
    template: require('../states/edit/view.html')
    resolve:
      sprint: ['$stateParams', 'Sprint', ($stateParams, Sprint) -> Sprint.new($stateParams.projectId)]

  .state 'tab.edit-sprint',
    url: '/sprint/:sprintId/edit'
    controller: 'EditSprintCtrl'
    template: require('../states/edit/view.html')
    resolve:
      sprint: ['$stateParams', 'Sprint', '$state', ($stateParams, Sprint, $state) ->
        Sprint.get(sprintId: $stateParams.sprintId)
        .catch (err) ->
          $state.go('tab.new-sprint')
      ]

  .state 'tab.sprint-list',
    url: '/project/:projectId/sprints'
    controller: 'SprintListCtrl'
    template: require('../states/list/view.html')
    resolve:
      project: ['Project', '$stateParams', (Project, $stateParams) ->
        Project.get(
          projectId: $stateParams.projectId
          filter:
            include:
              relation: 'sprints'
              scope:
                order: 'number DESC'
        )
      ]

  .state 'tab.bdc',
    url: '/'
    controller: 'BoardCtrl'
    template: require('../states/bdc/view.html')
    resolve:
      checkProjectAndSprint: ['project', 'sprint', '$state', (project, sprint, $state) ->
        return $state.go 'tab.project' unless project?
        return $state.go('tab.new-sprint', projectId: project.id) unless sprint?
      ]
]