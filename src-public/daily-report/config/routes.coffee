angular.module 'NotSoShitty.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyMail: (UserBoardStorage, DailyMailStorage) ->
        UserBoardStorage.getBoardId()
        .then (boardId) ->
          DailyMailStorage.get(boardId)
