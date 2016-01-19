angular.module 'Scrumble.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $mdDialog
  $state
  Sprint
  projectUtils
  project
  sprint
  Project
) ->
  $scope.project = project
  $scope.sprint = sprint

  $scope.toggleSidenav = ->
    $mdSidenav('left').toggle()

  showConfirmNewSprint = (ev) ->
    confirm = $mdDialog.confirm()
      .title 'Start a new sprint'
      .textContent 'Starting a new sprint will end this one'
      .targetEvent ev
      .ok 'OK'
      .cancel 'Cancel'
    $mdDialog.show(confirm).then ->
      $state.go 'tab.new-sprint'

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

  $scope.menu = [
    title: 'Project'
    items: [
      state: 'tab.project'
      title: 'Settings'
      icon: 'settings'
    ,
      state: 'tab.sprint-list'
      params:
        projectId: null
      title: 'Sprints'
      icon: 'view-list'
    ,
    ]
  ,
    title: 'Sprint'
    items: [
      state: 'tab.edit-sprint'
      params:
        sprintId: null
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
  updateMenuLinks()
