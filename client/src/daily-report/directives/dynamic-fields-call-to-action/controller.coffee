angular.module 'Scrumble.daily-report'
.controller 'DynamicFieldsCallToActionCtrl', (
  $scope
  $mdDialog
  $mdMedia
  dynamicFields
) ->
  $scope.openModal = (ev) ->
    useFullScreen = ($mdMedia 'sm' or $mdMedia 'xs')
    $mdDialog.show
      controller: 'DynamicFieldsModalCtrl'
      template: require('../dynamic-fields-dialog/view.html')
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: useFullScreen
      resolve:
        availableFields: -> dynamicFields.getAvailableFields()
