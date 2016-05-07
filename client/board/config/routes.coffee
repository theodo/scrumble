angular.module 'Scrumble.board'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.board',
    url: '/'
    controller: 'BoardCtrl'
    templateUrl: 'board/states/board/view.html'
    resolve:
      checkProjectAndSprint: (project, sprint, $state) ->
        return $state.go 'tab.project' unless project?
        return $state.go 'tab.new-sprint' unless sprint?
    onEnter: (sprint, $state) ->
      if sprint.bdcData?
        # the date is saved as a string so we've to convert it
        for day in sprint.bdcData
          day.date = moment(day.date).toDate()
