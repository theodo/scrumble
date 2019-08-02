angular.module 'Scrumble.daily-report'
.service 'bigBenReport', (BIGBEN_API_KEY) ->

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
        return daily.done != null
      )
      lastSprint = filteredSprint[ filteredSprint.length - 1 ]

      requestParams = {}

      requestBody = {
        name: sprint.project.name,
        trello_id: sprint.project.boardId,
        daily_mails: [
          {
            advance: lastSprint.done - lastSprint.standard,
            celerity: sprint.resources.speed
          }
        ]
      }

      requestAdditionalParams = {
        headers: {'Content-Type': 'application/json'},
      }

      # apigClient represents AWS API Gateway client coming from AWS SDK exported from BigBen AWS API.
      # This SDK needs to be re-exported and updated in local folder each time BigBen API is modified.
      # To do so, follow AWS documentation: https://docs.aws.amazon.com/apigateway/latest/developerguide/genearte-javascript-sdk-of-an-api.html
      #
      # Below, we use this SDK to send signed HTTP requests to BigBen AWS API.
      # More information available at: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-generate-sdk-javascript.html
      #
      apigClient = apigClientFactory.newClient({
        region: 'eu-west-1',
        apiKey: BIGBEN_API_KEY,
      });

      apigClient.projectsPost(
        requestParams,
        requestBody,
        requestAdditionalParams
      )