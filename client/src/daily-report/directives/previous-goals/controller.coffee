angular.module 'Scrumble.daily-report'
.controller 'PreviousGoalsCtrl', ['$scope', 'trelloCards', (
  $scope
  trelloCards
) ->
  $scope.errors = {}
  unless $scope.sprint?.doneColumn?
    $scope.errors.doneColumnMissing = true

  if $scope.sprint?.doneColumn?
    doneCardIdsPromise = trelloCards.getDoneCardIds $scope.sprint.doneColumn
    .then (cardIds) ->
      if _.isString $scope.markdown
        $scope.markdown = $scope.markdown.replace /card-id='(.+?)\'/g, (match, cardId) ->
          if cardId in cardIds
            return "style='color: green;'"
          else
            return "style='color: red;'"
]