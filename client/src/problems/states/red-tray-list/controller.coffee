angular.module 'Scrumble.problems'
.controller 'RedTrayListCtrl', (
  $scope,
  $mdDialog,
  $mdMedia,
  $stateParams,
  Problem
) ->
  fetchPieces = ->
    $scope.loading = true
    Problem.query(
      filter:
        where:
          type: 'red-tray'
          projectId: $stateParams.projectId
        order: 'happenedDate DESC'
    ).then (pieces) ->
      $scope.pieces = pieces
      $scope.loading = false

  $scope.editPiece = (piece, ev) ->
    open(piece, ev)

  $scope.addPiece = (ev) ->
    open(null, ev)

  open = (piece, ev) ->
    $mdDialog.show
      controller: 'AddRedTrayPieceCtrl'
      templateUrl: 'problems/states/red-tray-edit/view.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        problem: (Problem) -> angular.copy(piece) or Problem.new()
    .then fetchPieces

  fetchPieces()
