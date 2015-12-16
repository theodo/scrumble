angular.module 'NotSoShitty.daily-report'
.service 'reportBuilder', ($q, NotSoShittyUser, Sprint, Project, trelloUtils)->
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

  renderPoints = (message) ->
    promise.then ->
      trelloUtils.getColumnPoints project.columnMapping.toValidate
    .then (points) ->
      replace message, '{toValidate}', points
    .then (message) ->
      trelloUtils.getColumnPoints sprint.doneColumn
      .then (points) ->
        replace message, '{done}', points
    .then (message) ->
      trelloUtils.getColumnPoints project.columnMapping.blocked
      .then (points) ->
        replace message, '{blocked}', points
    .then (message) ->
      replace message, '{total}', sprint.resources.totalPoints

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
      renderPoints message
    .then (message) ->
      renderBDC message, sprint.bdcBase64, useCid
