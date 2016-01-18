angular.module 'Scrumble.common'
.controller 'BaseCtrl', (
  $scope
  $mdSidenav
  $mdDialog
  $state
  Sprint
  projectUtils
) ->
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

  projectUtils.getCurrentProject().then (project) ->
    $scope.menu[0].items[1].params.projectId = project.objectId

    Sprint.getActiveSprint(project).then (sprint) ->
      _.each $scope.menu, (section) ->
        items = _.filter section.items, (item) ->
          item.params?.sprintId?
        for item in items
          item.params.sprintId = sprint.objectId



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
