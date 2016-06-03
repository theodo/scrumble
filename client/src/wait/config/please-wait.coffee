angular.module 'Scrumble.wait'
.run ($rootScope, $state, $window, loadingToast) ->
  finish = ->
    unless $window.loading_screen.finishing
      $window.loading_screen.finish()

  $rootScope.$on '$stateChangeSuccess', ->
    # loadingToast.hide 'loading'
    finish()
  $rootScope.$on '$stateChangeError', ->
    # loadingToast.hide 'loading'
    finish()
  $rootScope.$on '$stateNotFound', ->
    # loadingToast.hide 'loading'
    finish()
  # $rootScope.$on '$stateChangeStart', ->
  #   loadingToast.show 'loading'
  #   finish()
