angular.module 'Scrumble.models'
.service 'ScrumbleUser2', ($resource) ->
  $resource(
    "#{API_URL}/ScrumbleUsers/:userId:action",
    {userId: '@id'},
    login:
      method: 'POST'
      params:
        action: 'trello-login'
    setProject:
      method: 'PUT'
      params:
        action: 'project'
  )
