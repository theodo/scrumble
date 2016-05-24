angular.module 'Scrumble.storage'
.service 'userService', (ScrumbleUser) ->
  getOrCreate: (email) ->
    ScrumbleUser.query(
      where:
        email: email
    )
    .then (users) ->
      if users.length > 0
        return users[0]
      else
        user = new User()
        user.email = email
        user.save().then (user) ->
          return user
