angular.module 'NotSoShitty.gmail-client'
.service 'mailer', ($state, $rootScope, GAuth) ->
  send: (message, callback) ->
    console.log 'before check auth'
    GAuth.checkAuth().then ->
      # return callback message: "No 'to' field", code: 400 unless message.to?
      # return callback message: "No 'subject' field", code: 400 unless message.subject?
      # return callback message: "No 'body' field", code: 400 unless message.body?
      #
      # user = $rootScope.gapi.user
      # now = new Date()
      # now = now.toString()
      # email_lines = []
      # email_lines.push "From: #{user.name} <#{user.email}>"
      # email_lines.push "To: #{message.to}"
      # if message.cc?
      #   email_lines.push "Cc: #{message.cc}"
      # email_lines.push 'Content-type: text/html;charset=iso-8859-1'
      # email_lines.push 'MIME-Version: 1.0'
      # email_lines.push "Subject: #{message.subject}"
      # email_lines.push "Date: #{now}"
      # email_lines.push 'Message-ID: <1234@local.machine.example>'
      # email_lines.push "#{message.body}"
      # email = email_lines.join('\r\n').trim()
      # base64EncodedEmail = btoa email
      # base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_')
      console.log 'after check auth'
      originalMail =
        to: 'nic.girault@gmail.com'
        subject: 'Today is rainy'
        fromName: 'John Smith'
        from: 'john.smith@mail.com'
        body: '<p>Sample body text<br><img src=\'cid:bdc\'></p>'
        cids: [ {
          type: 'image/png'
          name: 'toto'
          base64: 'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=='
          id: 'bdc'
        } ]
        'attaches': []
      base64EncodedEmail = btoa(Mime.toMimeTxt(originalMail))
      base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_')
      console.log 'sending email'
      request = gapi.client.gmail.users.messages.send
        userId: 'me'
        resource:
          raw: base64EncodedEmail

      request.execute callback
    , -> $state.go 'tab.google-login'
