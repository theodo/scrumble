angular.module 'NotSoShitty.sprint'
.config ($stateProvider) ->
  $stateProvider
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
        Sprint.find($stateParams.sprintId)
        .then (sprint) ->
          if sprint.bdcData?
            # the date is saved as a string so we've to convert it
            for day in sprint.bdcData
              day.date = moment(day.date).toDate()
          if sprint?.dates?.start?
            sprint.dates.start = moment(sprint.dates.start).toDate()
          if sprint?.dates?.end?
            sprint.dates.end = moment(sprint.dates.end).toDate()
          sprint
        .catch (err) ->
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
