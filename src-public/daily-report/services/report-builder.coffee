angular.module 'NotSoShitty.daily-report'
.service 'reportBuilder', ($q, NotSoShittyUser, Sprint)->
  deferred = $q.defer()
  deferred.resolve()
  promise = deferred.promise
  project = null
  sprint =
    number: '10'
    # "project", "dates", "resources", "bdcData", "isActive", "doneColumn"
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

  dateFormat: (_dateFormat_) ->
    dateFormat = _dateFormat_

  init: ->
    # promise = NotSoShittyUser.getCurrentUser().then (user) ->
    #   project = user.project
    #   project
    # .then (project) ->
    #   Sprint.getActiveSprint(new Project project).then (_sprint_) ->
    #     sprint = _sprint_
  render: (message) ->
    renderSprintNumber angular.copy message
    .then (message) ->
      renderDate message
