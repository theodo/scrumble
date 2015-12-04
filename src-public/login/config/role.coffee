angular.module 'NotSoShitty.login'
.run (Permission, $auth, $q) ->
  Permission.defineRole 'trello-authenticated', ->
    $auth.isAuthenticated()
