angular.module 'NotSoShitty.storage'
.service 'userService', (NotSoShittyUser) ->
  getOrCreate: (email) ->
    NotSoShittyUser.query(
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
