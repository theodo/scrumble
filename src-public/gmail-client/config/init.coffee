angular.module 'NotSoShitty.gmail-client'
.run (GApi, GAuth) ->
    GApi.load 'gmail', 'v1'
    GAuth.setClient '605908567890-3bg3dmamghq5gd7i9sqsdhvoflef0qku.apps.googleusercontent.com'
    GAuth.setScope 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/gmail.send'
