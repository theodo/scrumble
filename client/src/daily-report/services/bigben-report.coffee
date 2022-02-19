angular.module 'Scrumble.daily-report'
.constant 'BIGBEN_REPORT_ENDPOINT', 'https://api.bigben.theo.do/projects'
.service 'bigBenReport', ['$http', 'BIGBEN_REPORT_ENDPOINT', ($http, BIGBEN_REPORT_ENDPOINT) ->

  isTheodoSprint = (emailAdresses) ->
    for email in emailAdresses
      if email.endsWith("theodo.fr")
        return true
    return false

  send: (sprint) ->
    teamMembersEmail = sprint.project.team.map((teamMember) ->
      return teamMember.email)
    if isTheodoSprint teamMembersEmail
      filteredSprint = sprint.bdcData.filter((daily) ->
        return daily.done
      )
      lastSprint = filteredSprint[ filteredSprint.length - 1 ]
      data = {
        name: sprint.project.name,
        trello_id: sprint.project.boardId,
        daily_mails: [
          {
            advance: lastSprint.done - lastSprint.standard,
            celerity: sprint.resources.speed
          }
        ]
      }
      $http.post(
        BIGBEN_REPORT_ENDPOINT,
        data,
        headers: {'Content-Type': 'application/json'}
      )
]