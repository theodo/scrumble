angular.module 'Scrumble.problems'
.controller 'BoardGroupCtrl', (
  $scope
  $mdDialog
  BoardGroup
  TrelloClient
) ->
  TrelloClient.get('/members/me/boards?filter=open&fields=name,prefs')
  .then (response) ->
    $scope.boards = response.data
    $scope.boardsMap = _.keyBy response.data, 'id'

    BoardGroup.mine().then (groups) ->
      $scope.groups = groups

  $scope.edit = (ev, group) ->
    $mdDialog.show
      controller: 'AddBoardGroupCtrl'
      templateUrl: 'problems/states/board-groups/add.html'
      targetEvent: ev
      parent: angular.element(document.body)
      clickOutsideToClose: true
      resolve:
        group: ->
          return group if group?
          BoardGroup.new()
        boards: ->
          $scope.boards
    .then ->
      BoardGroup.mine()
    .then (groups) ->
      $scope.groups = groups

  $scope.delete = (group, ev) ->
    confirm = $mdDialog.confirm()
    .title 'Delete this group'
    .ariaLabel 'delete'
    .targetEvent(ev)
    .ok 'Yes do it!'
    .cancel 'Cancel'
    .clickOutsideToClose true

    $mdDialog.show(confirm).then ->
      BoardGroup.delete(id: group.id)
    .then ->
      BoardGroup.mine()
    .then (groups) ->
      $scope.groups = groups
