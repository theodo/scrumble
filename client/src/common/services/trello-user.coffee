angular.module 'Scrumble.common'
.service 'trelloUser', () ->
  shortName: (user) ->
    unless user?.fullName?
      return user

    names = user.fullName.split(" ")
    firstName = names.shift()
    _.reduce names, (string, name) ->
      string + name[0]
    , "@" + firstName
