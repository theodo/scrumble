angular.module 'Scrumble.gmail-client'
.service 'mailer', ($state, $rootScope, gmailClient, googleAuth) ->
  send: (message, callback) ->
    return callback message: "No 'to' field", code: 400 unless message.to?
    return callback message: "No 'subject' field", code: 400 unless message.subject?
    return callback message: "No 'body' field", code: 400 unless message.body?
    googleAuth.getUserInfo().then (user) ->
      originalMail =
        to: message.to
        cc: message.cc
        subject: message.subject
        fromName: user.name
        from: user.email
        body: message.body
        cids: message.cids
        attaches: []
      base64EncodedEmail = btoa(Mime.toMimeTxt(originalMail))
      base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_')

      gmailClient.send base64EncodedEmail
      .then callback
