angular.module 'Scrumble.login'
.controller 'TrelloLoginCtrl', (
  $scope
  $rootScope
  TrelloApi
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
    TrelloApi.Authenticate()
    .then ->
      ScrumbleUser2.login(trelloToken: TrelloApi.Token()).$promise
    .then (response) ->
      ApiAccessToken.set response.token
      $state.go 'tab.bdc'
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
