angular.module 'Scrumble.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $state
  Sprint
  Project
  sprint
  project
) ->
  # since views are nested, project and sprint objects will be available
  # for all child states
  $scope.project = project
  $scope.sprint = sprint

  $scope.toggleSidenav = ->
    $mdSidenav('left').toggle()

  $scope.goTo = (item) ->
    $state.go item.state, item.params
    $mdSidenav('left').close()

  updateMenuLinks = ->
    _.each $scope.menu, (section) ->
      _.each section.items, (item) ->
        if item.params?
          item.params.sprintId = $scope.sprint.objectId
          item.params.projectId = $scope.project.objectId

  $scope.$on 'project:update', (event, data) ->
    Project.find data.project.objectId
    .then (foundProject) ->
      $scope.project = foundProject

      Sprint.getActiveSprint foundProject
    .then (activeSprint) ->
      $scope.sprint = activeSprint
    .then ->
      updateMenuLinks()
      if data.nextState?
        $state.go data.nextState

  $scope.$on 'sprint:update', (event, data) ->
    $scope.sprint = data.sprint
    updateMenuLinks()
    if data.nextState?
      $state.go data.nextState

  $scope.menu = [
    title: 'Project'
    items: [
      state: 'tab.project'
      title: 'Settings'
      icon: 'settings'
    ,
      state: 'tab.sprint-list'
      params:
        projectId: $scope.project?.objectId
      title: 'Sprints'
      icon: 'view-list'
    ,
    ]
  ,
    title: 'Current Sprint'
    items: [
      state: 'tab.edit-sprint'
      params:
        sprintId: $scope.sprint?.objectId
      title: 'Settings'
      icon: 'settings'
    ,
      state: 'tab.board'
      title: 'Burndown Chart'
      icon: 'trending-down'
    ,
      state: 'tab.new-sprint'
      title: 'Start New Sprint'
      icon: 'plus'
    ,
    ]
  ,
    title: 'Daily Mail'
    items: [
      state: 'tab.daily-report'
      title: 'Write Today\'s Daily'
      icon: 'gmail'
    ,
      state: 'tab.edit-template'
      title: 'Edit Template'
      icon: 'code-braces'
    ,
    ]
  ]
