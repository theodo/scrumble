angular.module 'NotSoShitty.gmail-client'
.service 'gmailAuth',  ->

  template = "<h1>Test</h1>"

  CLIENT_ID =
    '599154729473-sjs1d17pld1spgehnsa44braraef98sv.apps.googleusercontent.com'
  SCOPES = [ 'https://www.googleapis.com/auth/gmail.send' ]

  ###*
  # Handle response from authorization server.
  #
  # @param {Object} authResult Authorization result.
  ###

  handleAuthResult = (authResult) ->
    authorizeDiv = document.getElementById('authorize-div')
    if authResult and !authResult.error
  # Hide auth UI, then load client library.
      authorizeDiv.style.display = 'none'
      loadGmailApi()
    else
  # Show auth UI, allowing the user to initiate authorization by
  # clicking authorize button.
      authorizeDiv.style.display = 'inline'
    return

  ###*
  # Load Gmail API client library. List labels once client library
  # is loaded.
  ###

  loadGmailApi = ->
    gapi.client.load 'gmail', 'v1', listLabels
    return

  ###*
  # Print all Labels in the authorized user's inbox. If no labels
  # are found an appropriate message is printed.
  ###

 listLabels = ->
   request = gapi.client.gmail.users.labels.list('userId': 'me')
   request.execute (resp) ->
     labels = resp.labels
     appendPre 'Labels:'
     if labels and labels.length > 0
       i = 0
       while i < labels.length
         label = labels[i]
         appendPre label.name
         i++
     else
       appendPre 'No Labels found.'
     return
   return

  sendMail = ->
    email_lines = []
    email_lines.push "From: Nicolas Goutay <nicolas.goutay@gmail.com>"
    email_lines.push 'To: nicolas.goutay@gmail.com'
    email_lines.push 'Content-type: text/html;charset=iso-8859-1'
    email_lines.push 'MIME-Version: 1.0'
    email_lines.push 'Subject: New future subject here'
    email_lines.push 'Date: Fri, 21 Nov 1997 09:55:06 -0600'
    email_lines.push 'Message-ID: <1234@local.machine.example>'
    email_lines.push template
    email = email_lines.join('\r\n').trim()
    base64EncodedEmail = new Buffer(email).toString('base64')
    base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_')
    request = gapi.client.gmail.users.messages.send
      userId: 'me'
      resource:
        raw: base64EncodedEmail

    request.execute (response) -> console.log response

  ###*
  # Append a pre element to the body containing the given message
  # as its text node.
  #
  # @param {string} message Text to be placed in pre element.
  ###

  appendPre = (message) ->
    pre = document.getElementById('output')
    textContent = document.createTextNode(message + '\n')
    pre.appendChild textContent
    return
