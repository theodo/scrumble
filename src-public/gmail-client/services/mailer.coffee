angular.module 'NotSoShitty.gmail-client'
.service 'mailer', ($state, $rootScope, GAuth) ->
  send: (message, callback) ->
    GAuth.checkAuth().then ->
      return callback message: "No 'to' field", code: 400 unless message.to?
      return callback message: "No 'subject' field", code: 400 unless message.subject?
      return callback message: "No 'body' field", code: 400 unless message.body?

      user = $rootScope.gapi.user

      originalMail =
        to: message.to
        subject: message.subject
        fromName: user.name
        from: user.email
        body: message.body
        cids: message.cids
        attaches: []
      base64EncodedEmail = btoa(Mime.toMimeTxt(originalMail))
      base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_')

      request = gapi.client.gmail.users.messages.send
        userId: 'me'
        resource:
          raw: base64EncodedEmail

      request.execute callback
    , -> $state.go 'tab.google-login'
