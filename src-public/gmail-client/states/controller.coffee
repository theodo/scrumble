angular.module 'NotSoShitty.gmail-client'
.controller 'GmailClientCtrl', (
  $scope,
  $rootScope,
  $state,
  gmailAuth
  ) ->
  

  # Your Client ID can be retrieved from your project in the Google
  # Developer Console, https://console.developers.google.com
  CLIENT_ID =
    '605908567890-3bg3dmamghq5gd7i9sqsdhvoflef0qku.apps.googleusercontent.com'
  SCOPES = [ 'https://www.googleapis.com/auth/gmail.send' ]

  ###*
  # Check if current user has authorized this application.
  ###

  $scope.checkAuth = ->
    gapi.auth.authorize {
      'client_id': CLIENT_ID
      'scope': SCOPES.join(' ')
      'immediate': true
    }, gmailAuth.handleAuthResult
    return

  ###*
  # Initiate auth flow in response to user clicking authorize button.
  #
  # @param {Event} event Button click event.
  ###

  $scope.handleAuthClick = (event) ->
    gapi.auth.authorize {
      client_id: CLIENT_ID
      scope: SCOPES
      immediate: false
    }, gmailAuth.handleAuthResult
    false
