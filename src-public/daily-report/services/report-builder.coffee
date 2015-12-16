angular.module 'NotSoShitty.daily-report'
.service 'reportBuilder', ($q, NotSoShittyUser, Sprint, Project)->
  promise = undefined
  project = undefined
  sprint = undefined

  replace = (message, toRemplace, replacement) ->
    message.subject = message.subject.replace toRemplace, replacement
    message.body = message.body.replace toRemplace, replacement
    message

  renderSprintNumber = (message) ->
    promise.then ->
      replace message, '{sprintNumber}', sprint.number

  renderDate = (message) ->
    promise.then ->
      replace message, /\{today#(.+?)\}/g, (match, dateFormat) ->
        moment().format dateFormat

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

  dateFormat: (_dateFormat_) ->
    dateFormat = _dateFormat_

  init: ->
    promise = NotSoShittyUser.getCurrentUser().then (user) ->
      project = user.project
      project
    .then (project) ->
      Sprint.getActiveSprint(new Project project).then (_sprint_) ->
        sprint = _sprint_

  render: (message, useCid) ->
    renderSprintNumber angular.copy message
    .then (message) ->
      renderDate message
    .then (message) ->
      renderBDC message, sprint.bdcBase64, useCid
