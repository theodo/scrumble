angular.module 'Scrumble.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $state
  $ngLoad
  Sprint
  Project
  sprint
  project
) ->
  # since views are nested, project and sprint objects will be available
  # for all child states
  $scope.project = project
  $scope.sprint = sprint

  window.HW_config =
    selector: '#changelog'
    account: 'Wyprg7'
  $ngLoad '//cdn.headwayapp.co/widget.js'

  $scope.toggleSidenav = ->
    $mdSidenav('left').toggle()

  $scope.goTo = (item) ->
    $state.go item.state, item.params
    $mdSidenav('left').close()

  $scope.$on 'project:update', (event, data) ->
    $state.reload 'tab'
    .then ->
      if data?.nextState?
        $state.go data.nextState

  $scope.$on 'sprint:update', (event, data) ->
    $state.reload 'tab'
    .then ->
      if data?.nextState?
        $state.go data.nextState

  $scope.menu = [
    title: 'Project'
    items: [
      state: 'tab.new-sprint'
      title: 'Start New Sprint'
      icon: 'plus'
    ,
      state: 'tab.team'
      title: 'Team'
      icon: 'account-multiple'
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
      state: 'tab.board'
      title: 'Burndown Chart'
      icon: 'trending-down'
    ,
      state: 'tab.indicators'
      params:
        sprintId: $scope.sprint?.objectId
      title: 'Indicators'
      icon: 'chart-bar'
    ,
      state: 'tab.edit-sprint'
      params:
        sprintId: $scope.sprint?.objectId
      title: 'Settings'
      icon: 'settings'
    ,
    ]
  ,
    title: 'Daily Mail'
    items: [
      state: 'tab.daily-report'
      title: 'Write Today\'s Daily'
      icon: 'gmail'
    ,
    ]
  ]
