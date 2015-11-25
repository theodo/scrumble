angular.module 'NotSoShitty.settings'
.factory 'Avatar', (TrelloApi) ->
  getMember: (memberId) ->
    return unless memberId
    TrelloApi.members memberId
    .then (member) ->
      if member.uploadedAvatarHash
        hash = member.uploadedAvatarHash
      else if member.avatarHash
        hash = member.avatarHash
      else
        hash = null
      return {
        username: member.username
        fullname: member.fullname
        hash: hash
        initials: member.initials
      }
