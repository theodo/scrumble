angular.module 'Scrumble.common'
.service 'loadingToast', ($mdToast) ->
  toast = $mdToast.build(
    templateUrl: 'common/views/loading-toast.html'
    position: 'top left'
  )

  show: -> $mdToast.show toast
  hide: -> $mdToast.hide toast
