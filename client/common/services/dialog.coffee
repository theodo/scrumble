angular.module 'Scrumble.common'
.service 'nssModal', ($mdDialog, $mdMedia) ->
  show: (options) ->
    useFullScreen = $mdMedia('sm') or $mdMedia('xs')

    $mdDialog.show
      controller: options.controller
      templateUrl: options.templateUrl
      targetEvent: options.targetEvent
      resolve: options.resolve
      parent: angular.element(document.body)
      clickOutsideToClose: true
      fullscreen: useFullScreen
