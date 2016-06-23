angular.module 'Scrumble.indicators'
.controller 'ClientFormCtrl', (
  $scope
  loadingToast
  Sprint
  GAuth
  GApi
  GData
) ->
  if _.isArray $scope.sprint?.indicators?.satisfactionSurvey
    for question, index in $scope.sprint.indicators.satisfactionSurvey
      $scope.template[index].answer = question.answer

  # Google API Authentify information
  GAuth.setClient('947504094757-i7k95sfqlq1jk6vq9iijmp78kcm0u00g.apps.googleusercontent.com')
  GAuth.setScope('https://www.googleapis.com/auth/spreadsheets')
  GApi.load('sheets','v4','').catch (api, version) ->
    console.log('an error occured during loading api: ' + api + ', version: ' + version)

  $scope.SPREADSHEET_ID = '1qeRBk1TMi9zoaQUz9Zqlasb_w0w2_ehcYk5zApdzefU'

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
      $scope.googleAuthentified = true
      $scope.googleAuthentifying = false
      return
    ), ->
      $scope.googleAuthentified = false
      $scope.googleAuthentifying = false
      return

  $scope.helloWorldInSpreadsheet = ->
    $scope.savingInSpreadsheet = true
    $scope.queryParams = {
      spreadsheetId: '1qeRBk1TMi9zoaQUz9Zqlasb_w0w2_ehcYk5zApdzefU'
      range: 'Sheet1!A1:A1'
      majorDimension: 'ROWS'
      valueInputOption: 'RAW'
      values: [['Bonjour le monde']]
    }
    GApi.executeAuth('sheets', 'spreadsheets.values.update', $scope.queryParams).then ((resp) ->
      $scope.savingInSpreadsheet = false
      return
    ), ->
      $scope.savingInSpreadsheet = false
      return
    return

  $scope.print = ->
    window.print()

  $scope.googleAuthentified = false
  $scope.googleCheckAuthentified()
