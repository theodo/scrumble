angular.module 'NotSoShitty.login'
.config ($stateProvider) ->
  $stateProvider
  .state 'trello-login',
    url: '/login/trello'
    controller: 'TrelloLoginCtrl'
    templateUrl: 'login/states/trello/view.html'
    resolve:
      dummy: (localStorageService, $state, $q) ->
        deferred = $q.defer()
        if localStorageService.get 'trello_token'
          $state.go 'tab.current-sprint'
        else
          deferred.resolve()

        deferred.promise
