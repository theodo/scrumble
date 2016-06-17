angular.module 'Scrumble.indicators'
.service 'GoogleSpreadsheetUtils', (Sprint) ->

  CLIENT_ID = '947504094757-jahn1uethbjdfp8n8ekk5d43k2dtjjvr.apps.googleusercontent.com'
  SCOPES = [ 'https://www.googleapis.com/auth/spreadsheets' ]

  ###*
  # Check if current user has authorized this application.
  ###
  checkAuth = ->
    window.gapi.auth.authorize {
      'client_id': CLIENT_ID
      'scope': SCOPES.join(' ')
      'immediate': true
    }, handleAuthResult
    return

  ###*
  # Handle response from authorization server.
  #
  # param {Object} authResult Authorization result.
  ###
  handleAuthResult = (authResult) ->
    if authResult and !authResult.error
      # Hide auth UI, then load client library.
      loadSheetsApi()
    else
      # Show auth UI, allowing the user to initiate authorization by
      # clicking authorize button.
    return

  ###*
  # Initiate auth flow in response to user clicking authorize button.
  #
  ###
  handleAuthClick = ->
    window.gapi.auth.authorize {
      client_id: CLIENT_ID
      scope: SCOPES
      immediate: false
    }, handleAuthResult
    false

  ###*
  # Load Sheets API client library.
  ###
  loadSheetsApi = ->
    discoveryUrl = 'https://sheets.googleapis.com/$discovery/rest?version=v4'
    window.gapi.client.load(discoveryUrl).then processData
    return

  ###*
  # Print the names and majors of students in a sample spreadsheet:
  # https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
  ###
  processData = ->
    window.gapi.client.sheets.spreadsheets.values.update(
      spreadsheetId: '1qeRBk1TMi9zoaQUz9Zqlasb_w0w2_ehcYk5zApdzefU'
      range: 'Sheet1!A1:A1'
      majorDimension: 'ROWS'
      valueInputOption: 'RAW'
      values: [['Hello world']]).then ((response) ->
    ), (response) ->
      appendPre 'Error: ' + response.result.error.message
      return
    return

  ###*
  # Append a pre element to the body containing the given message
  # as its text node.
  #
  # param {string} message Text to be placed in pre element.
  ###
  appendPre = (message) ->
    console.log(message)
    return

  handleAuthClick: handleAuthClick
