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
