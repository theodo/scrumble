angular.module 'Scrumble.gmail-client'
.constant 'SEND_EMAIL_ENDPOINT', 'https://content.googleapis.com/gmail/v1/users/me/messages/send'
.service 'gmailClient', ['$http', 'googleAuth', 'SEND_EMAIL_ENDPOINT', ($http, googleAuth, SEND_EMAIL_ENDPOINT) ->
  send: (raw) ->
    $http.post(
      SEND_EMAIL_ENDPOINT,
      {
        raw: raw
      },
      {
        headers: {
          authorization: googleAuth.getAuthorizationHeader()
        },
        params: {
          alt: "json"
        }
      }
    )
]