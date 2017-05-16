angular.module 'Scrumble.common'
.filter 'userShortName', (trelloUser) ->
  (user) ->
    trelloUser.shortName user
