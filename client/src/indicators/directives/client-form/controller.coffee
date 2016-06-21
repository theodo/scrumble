angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  loadingToast
  Sprint
  GAuth
  GApi
  GData
) ->
  _.forEach $scope.sprint?.indicators?.satisfactionSurvey, (question, index) ->
    $scope.template[index].answer = question.answer

  # Google API Authentify information
  GAuth.setClient('947504094757-i7k95sfqlq1jk6vq9iijmp78kcm0u00g.apps.googleusercontent.com')
  GAuth.setScope('https://www.googleapis.com/auth/spreadsheets')

  $scope.save = ->
    loadingToast.show()
    $scope.saving = true
    $scope.sprint.indicators ?= {}
    $scope.sprint.indicators.satisfactionSurvey = $scope.template
    Sprint.save $scope.sprint
    .then ->
      loadingToast.hide()
      $scope.saving = false

  $scope.googleCheckAuthentified = ->
    $scope.googleAuthentifying = true
    GAuth.checkAuth().then ((user) ->
      $scope.googleAuthentified = true
      $scope.googleAuthentifying = false
      return
    ), ->
      $scope.googleAuthentified = false
      $scope.googleAuthentifying = false
      return

  $scope.googleAuthentify = ->
    $scope.googleAuthentifying = true
    GAuth.login().then ((user) ->
      console.log user.name + 'is login'
      $scope.googleAuthentified = true
      $scope.googleAuthentifying = false
      return
    ), ->
      $scope.googleAuthentified = false
      $scope.googleAuthentifying = false
      console.log 'login fail'
      return

  $scope.saveInSpreadsheet = ->
    $scope.googleAuthentify()
    return

  $scope.print = ->
    window.print()

  $scope.googleAuthentified = false
  $scope.googleCheckAuthentified()
