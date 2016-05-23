angular.module 'Scrumble.wait'
.service 'loadingToast', ($mdToast, $document) ->
  toastLoading = $mdToast.build(
    templateUrl: 'wait/views/loading-toast.html'
    position: 'top left'
    parent: $document[0].querySelector 'main'
  )
  toastSaving = $mdToast.build(
    templateUrl: 'wait/views/saving-toast.html'
    position: 'top left'
    parent: $document[0].querySelector 'main'
  )
  toastDeleting = $mdToast.build(
    templateUrl: 'wait/views/delete-toast.html'
    position: 'top left'
    parent: $document[0].querySelector 'main'
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
