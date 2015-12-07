angular.module 'NotSoShitty.storage'
.service 'DailyMailStorage', (DailyMail, $q) ->
  get: (boardId) ->
    deferred = $q.defer()
    if boardId?
      DailyMail.query(
        where:
          boardId: boardId
      ).then (response) ->
        if response.length > 0
          deferred.resolve response[0]
        else
          dailyMail = new DailyMail()
          dailyMail.boardId = boardId
          dailyMail.save().then (object) ->
            deferred.resolve object
      .catch deferred.reject
    else
      deferred.reject 'No boardId'
    deferred.promise
