angular.module 'Scrumble.login'
.controller 'TrelloLoginCtrl', (
  $scope
  $rootScope
  TrelloClient
  $state
  $auth
  $mdToast
  $document
  ScrumbleUser2
  ApiAccessToken
) ->
  $scope.doing = false

  $scope.login = ->
    $scope.doing = true
    TrelloClient.authenticate()
    .then (response) ->
      ScrumbleUser2.login(trelloToken: response.token).$promise
    .then (response) ->
      ApiAccessToken.set response.token
      $state.go 'tab.board'
    .catch (err) ->
      if err.status is -1
        $mdToast.show(
          $mdToast.simple()
          .textContent('Could not connect to API...')
          .position('top left')
          .hideDelay(3000)
          .parent($document[0].querySelector 'main')
        )
      $scope.doing = false
