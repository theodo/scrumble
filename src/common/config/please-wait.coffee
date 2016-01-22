angular.module 'Scrumble.common'
.run ($rootScope, $state, $window, loadingToast) ->
  finish = ->
    $window.loading_screen.finish()

  $rootScope.$on '$stateChangeSuccess', ->
    loadingToast.hide('loading')
    finish()
  $rootScope.$on '$stateChangeError', ->
    loadingToast.hide('loading')
    finish()
  $rootScope.$on '$stateNotFound', ->
    loadingToast.hide('loading')
    finish()
  $rootScope.$on '$stateChangeStart', ->
    loadingToast.show('loading')
    finish()
