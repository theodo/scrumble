angular.module 'Scrumble.problems'
.controller 'AddBoardGroupCtrl', (
  $scope
  $mdDialog
  TrelloClient
  BoardGroup
  group
  boards
) ->
  $scope.group = group
  $scope.saveGroup = ->
    $scope.group.boards = (board.id for board in $scope.selectedBoards)
    BoardGroup.save($scope.group)
    .then ->
      $mdDialog.hide()

  $scope.cancel = $mdDialog.hide

  $scope.boards = boards
  $scope.selectedBoards = _.filter boards, (board) ->
    return false unless $scope.group.boards?
    board.id in $scope.group.boards
