angular.module 'Scrumble.models'
.service 'ScrumbleUser2', ($resource, API_URL) ->
  $resource(
    "#{API_URL}/api/ScrumbleUsers/:userId:action",
    {userId: '@id'},
    login:
      method: 'POST'
      params:
        action: 'trello-login'
  )
