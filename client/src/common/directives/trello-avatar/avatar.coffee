angular.module 'Scrumble.common'
.factory 'Avatar', ['TrelloClient', (TrelloClient) ->
  getMember: (memberId) ->
    return unless memberId
    TrelloClient.get('/members/' + memberId)
    .then (response) ->
      if response.data.uploadedAvatarHash
        hash = response.data.uploadedAvatarHash
      else if response.data.avatarHash
        hash = response.data.id + '/' + response.data.avatarHash
      else
        hash = null
      return {
        username: response.data.username
        fullname: response.data.fullname
        hash: hash
        initials: response.data.initials
      }
]