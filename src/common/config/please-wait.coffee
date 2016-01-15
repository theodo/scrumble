angular.module 'Scrumble.common'
.run ($rootScope, $state, $window) ->
  finish = ->
    $window.loading_screen.finish()

  $rootScope.$on '$stateChangeSuccess', finish
  $rootScope.$on '$stateChangeError', finish
  $rootScope.$on '$stateNotFound', finish
