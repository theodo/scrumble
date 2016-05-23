angular.module 'Scrumble.login'
.run ($rootScope, $state, trelloAuth, localStorageService) ->
  $rootScope.$on '$locationChangeSuccess', ->
    unless trelloAuth.isLoggedUnsafe()
      localStorageService.clearAll()
      $state.go 'trello-login'
