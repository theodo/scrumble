angular.module 'Scrumble.common'
.controller 'BaseCtrl', ($scope, $mdSidenav, $state, project, sprint) ->
  $scope.toggleSidenav = ->
    $mdSidenav('left').toggle()

  $scope.goTo = (item) ->
    $state.go item.state, item.params
    $mdSidenav('left').close()

  $scope.menu = [
    title: 'Project'
    items: [
      state: 'tab.project'
      title: 'Settings'
      icon: 'settings'
    ,
      state: 'tab.sprint-list'
      params:
        projectId: project.objectId
      title: 'Sprints'
      icon: 'view-list'
    ,
    ]
  ,
    title: 'Sprint'
    items: [
      state: 'tab.board'
      title: 'Burndown Chart'
      icon: 'trending-down'
    ,
      state: 'tab.edit-sprint'
      params:
        sprintId: sprint.objectId
      title: 'Settings'
      icon: 'settings'
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
      params:
        sprintId: sprint.objectId
      title: 'Edit Template'
      icon: 'code-braces'
    ,
    ]
  ]
