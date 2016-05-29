angular.module 'Scrumble.login'
.config ($authProvider, API_URL, GOOGLE_CLIENT_ID) ->
  $authProvider.google
    clientId: GOOGLE_CLIENT_ID
    url: "#{API_URL}/ScrumbleUsers/auth/google"
    scope: [
      'https://www.googleapis.com/auth/userinfo.email'
      'https://www.googleapis.com/auth/gmail.send'
    ]
    redirectUri: window.location.origin + window.location.pathname
    optionalUrlParams: ['display', 'access_type']
    accessType: 'offline'
