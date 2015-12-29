angular.module 'NotSoShitty.daily-report'
.service 'reportBuilder', ($q, NotSoShittyUser, Sprint, Project, trelloUtils, dynamicFields)->
  converter = new showdown.Converter()

  promise = undefined
  project = undefined
  sprint = undefined

  renderBehindAhead = (message) ->
    getCurrentDayIndex = (bdcData) ->
      for day, i in bdcData
        return Math.max i-1, 0 unless day.done?
      return i - 1
    promise.then ->
      index = getCurrentDayIndex sprint.bdcData
      diff = sprint.bdcData[index].done - sprint.bdcData[index].standard
      label = if diff > 0 then message.aheadLabel else message.behindLabel
      message.body = message.body.replace '{behind/ahead}', label
      message.subject = message.subject.replace '{behind/ahead}', label

      message

  renderBDC = (message, bdcBase64, useCid) ->
    src = if useCid then 'cid:bdc' else bdcBase64
    promise.then ->
      message.body = message.body.replace '{bdc}', "<img src='#{src}' />"
      if useCid

        message.cids = [ {
          type: 'image/png'
          name: 'BDC'
          base64: bdcBase64.split(',')[1]
          id: 'bdc'
        } ]
      message

  renderTo = (message) ->
    promise.then ->
      devsEmails = (member.email for member in project.team.dev when member.daily is 'to')
      memberEmails = (member.email for member in project.team.rest when member.daily is 'to')
      message.to = _.filter _.union devsEmails, memberEmails
      message

  renderCc = (message) ->
    promise.then ->
      devsEmails = (member.email for member in project.team.dev when member.daily is 'cc')
      memberEmails = (member.email for member in project.team.rest when member.daily is 'cc')
      message.cc = _.filter _.union devsEmails, memberEmails
      message

  init: ->
    promise = NotSoShittyUser.getCurrentUser().then (user) ->
      project = user.project
      project
    .then (project) ->
      Sprint.getActiveSprint(new Project project).then (_sprint_) ->
        sprint = _sprint_

  render: (message, useCid) ->
    message = angular.copy message

    message.body = converter.makeHtml message.body

    dynamicFields.sprint sprint
    dynamicFields.project project

    dynamicFields.render message.subject
    .then (subject) ->
      message.subject = subject
      dynamicFields.render message.body
    .then (body) ->
      message.body = body
    .then ->
      renderBehindAhead message
    .then (message) ->
      renderBDC message, sprint.bdcBase64, useCid
    .then (message) ->
      renderTo message
    .then (message) ->
      renderCc message
