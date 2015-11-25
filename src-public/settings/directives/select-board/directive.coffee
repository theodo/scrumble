angular.module 'NotSoShitty.settings'
.directive 'selectBoard', ->
  restrict: 'E'
  templateUrl: 'settings/directives/select-board/view.html'
  scope:
    boards: '='
    boardId: '='
  controller: 'SelectBoardCtrl'
