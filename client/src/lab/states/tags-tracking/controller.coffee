angular.module 'Scrumble.lab'
.controller 'TagsTrackingCtrl', (
  $scope
  TrelloClient
  project
  $http
  $q
) ->
  $scope.chartConfig = {}
  $q.all [
    TrelloClient.get("/boards/#{project.boardId}/cards?fields=dateLastActivity,idList,idLabels,name,shortUrl,desc")
    TrelloClient.get("/boards/#{project.boardId}/labels")
    TrelloClient.get("/boards/#{project.boardId}/lists")
  ]
  # $q.all [
  #   $http.get("/trello-mock/cards.json")
  #   $http.get("/trello-mock/labels.json")
  #   $http.get("/trello-mock/lists.json")
  # ]
  .then ([cards, labels, lists]) ->
    $scope.chartConfig =
      options:
        chart:
          type: 'scatter'
        title: text: 'Labels over time'
        subtitle: text: 'Scrumble board'
      xAxis:
        type: 'datetime'
        title: text: 'Last Activity Date'
      yAxis:
        title: text: 'Random'
      plotOptions:
        scatter:
          marker:
            radius: 4
            states:
              hover:
                enabled: true
                lineColor: 'rgb(100,100,100)'
            states:
              hover:
                marker:
                  enabled: false
            tooltip:
              headerFormat: '<a href="{point.url}">{point.name}</a><br>'
              pointFormat: '<p>{point.desc}</p>'
      series: _.map labels.data, (label) ->
        labeledCards = _.filter cards.data, (card) ->
          label.id in card.idLabels
        name: label.name
        data: _.map labeledCards, (card) ->
          x: parseInt(moment(card.dateLastActivity).format('x'))
          y: Math.random()
          name: card.name
          url: card.shortUrl
          desc: card.desc
