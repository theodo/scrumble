loadingToastTemplate = require '../views/loading-toast.html'
savingToastTemplate = require '../views/saving-toast.html'
deleteToastTemplate = require '../views/delete-toast.html'

angular.module 'Scrumble.wait'
.service 'loadingToast', ($mdToast, $document) ->
  toastLoading = $mdToast.build(
    template: loadingToastTemplate
    position: 'top left'
    parent: $document[0].querySelector 'main'
  )
  toastSaving = $mdToast.build(
    template: savingToastTemplate
    position: 'top left'
    parent: $document[0].querySelector 'main'
  )
  toastDeleting = $mdToast.build(
    template: deleteToastTemplate
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
