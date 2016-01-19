angular.module 'Scrumble.sprint'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.new-sprint',
    url: '/sprint/edit'
    controller: 'EditSprintCtrl'
    templateUrl: 'sprint/states/edit/view.html'
    resolve:
      sprint: (ScrumbleUser, Project, Sprint) ->
        ScrumbleUser.getCurrentUser()
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
      sprint: (Sprint, $stateParams, $state) ->
        Sprint.find($stateParams.sprintId)
        .catch (err) ->
          $state.go 'tab.new-sprint'
    onEnter: (sprint) ->
      if sprint.bdcData?
        # the date is saved as a string so we've to convert it
        for day in sprint.bdcData
          day.date = moment(day.date).toDate()

      # check start/end date consistency
      if _.isArray(sprint?.dates?.days) and sprint?.dates?.days.length > 0
        [first, ..., last] = sprint.dates.days
        sprint.dates.start = moment(first.date).toDate()
        sprint.dates.end = moment(last.date).toDate()
      else
        sprint.dates.start = null
        sprint.dates.end = null
  .state 'tab.sprint-list',
    url: '/project/:projectId/sprints'
    controller: 'SprintListCtrl'
    templateUrl: 'sprint/states/list/view.html'
    resolve:
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
      sprints: (Sprint, $stateParams) ->
        Sprint.getByProjectId $stateParams.projectId
  .state 'print-bdc',
    url: '/project/:projectId/sprint/:sprintId/print'
    controller: 'PrintBDCCtrl'
    templateUrl: 'sprint/states/print-bdc/view.html'
    resolve:
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
      sprint: (Sprint, $stateParams) ->
        Sprint.find $stateParams.sprintId
