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

  renderBDC = (message) ->
    promise.then ->
      message.body = message.body.replace '{bdc}', '<img src="cid:bdc" />'
      message.cids = [ {
        type: 'image/png'
        name: 'BDC'
        base64: 'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=='
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

  render: (message) ->
    renderSprintNumber angular.copy message
    .then (message) ->
      renderDate message
    .then (message) ->
      renderBDC message
