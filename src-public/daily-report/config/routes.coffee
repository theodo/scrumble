angular.module 'NotSoShitty.daily-report'
.config ($stateProvider) ->
  $stateProvider
  .state 'daily-report',
    url: '/daily-report'
    templateUrl: 'daily-report/states/view.html'
    controller: 'DailyReportCtrl'
    resolve:
      dailyMail: (NotSoShittyUser) ->
        return
        # UserBoardStorage.getBoardId()
        # .then (boardId) ->
        #   DailyMailStorage.get(boardId)
    data:
      permissions:
        only: ['google-authenticated']
        redirectTo: 'google-login'
