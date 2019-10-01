angular.module 'Scrumble.login'
.run ($rootScope, $state, $location, trelloAuth, localStorageService) ->
  $rootScope.$on '$locationChangeSuccess', ->
    if (not trelloAuth.isLoggedUnsafe()) and (not ($location.url() is '/policy'))
      localStorageService.clearAll()
      $state.go 'trello-login'
