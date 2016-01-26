angular.module 'Scrumble.common'
.service 'loadingToast', ($mdToast) ->
  toastLoading = $mdToast.build(
    templateUrl: 'common/views/loading-toast.html'
    position: 'top left'
  )
  toastSaving = $mdToast.build(
    templateUrl: 'common/views/saving-toast.html'
    position: 'top left'
  )
  toastDeleting = $mdToast.build(
    templateUrl: 'common/views/delete-toast.html'
    position: 'top left'
  )

  show: (message) ->
    if message is 'loading'
      $mdToast.show toastLoading
    else if message is 'deleting'
      $mdToast.show toastDeleting
    else
      $mdToast.show toastSaving
  hide: (message) ->
    if message is 'loading'
      $mdToast.hide toastLoading
    else if message is 'deleting'
      $mdToast.hide toastDeleting
    else
      $mdToast.hide toastSaving
