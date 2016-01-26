angular.module 'Scrumble.daily-report'
.service 'reportBuilder', ($q, ScrumbleUser, Sprint, Project, trelloUtils, dynamicFields, bdc)->
  converter = new showdown.Converter()

  promise = undefined
  project = undefined
  sprint = undefined

  isAhead = ->
    getCurrentDayIndex = (bdcData) ->
      for day, i in bdcData
        return Math.max i-1, 0 unless day.done?
      return i - 1
    promise.then ->
      index = getCurrentDayIndex sprint.bdcData
      diff = sprint.bdcData[index].done - sprint.bdcData[index].standard
      if diff > 0 then true else false

  renderBehindAhead = (message) ->
    isAhead().then (ahead) ->
      label = if ahead then message.aheadLabel else message.behindLabel
      message.body = message.body.replace '{behind/ahead}', label
      message.subject = message.subject.replace '{behind/ahead}', label
      message

  renderTodaysGoals = (body, goals) ->
    return body unless _.isArray goals
    goalsNames = ("- " + goal.name for goal in goals)
    goalsString = goalsNames.join "\n"
    body.replace '{todaysGoals}', goalsString

  renderPreviousGoals = (body, goals) ->
    return body unless _.isArray goals
    goalsNames = []
    for goal in goals
      color = if goal.isDone then 'green' else 'red'
      goalsNames.push "- " + goal.name + " {color=#{color}}"
    goalsString = goalsNames.join "\n"
    body.replace '{previousGoals}', goalsString

  renderSection = (body, key, value) ->
    body.replace "{#{key}}", value

  renderColor = (message) ->
    isAhead().then (ahead) ->
      message.body = message.body.replace />(.*(\{color=(.+?)\}).*)</g, (match, line, toRemove, color) ->
        line = line.replace toRemove, ""
        if color is 'smart'
          color = if ahead then 'green' else 'red'
        "><span style='color: #{color};'>#{line}</span><"
      message

  renderBDC = (message, bdcBase64, useCid) ->
    console.log bdcBase64
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
      emails = (member.email for member in project.team when member.daily is 'to')
      message.to = _.filter emails
      message

  renderCc = (message) ->
    promise.then ->
      emails = (member.email for member in project.team when member.daily is 'cc')
      message.cc = _.filter emails
      message

  init: ->
    promise = ScrumbleUser.getCurrentUser().then (user) ->
      project = user.project
      project
    .then (project) ->
      Sprint.getActiveSprint(new Project project).then (_sprint_) ->
        sprint = _sprint_
  getAvailableFields: ->
    [
      key: '{bdc}'
      description: 'The burndown chart image'
      icon: 'trending-down'
    ,
      key: '{color=xxx}'
      description: 'This field will color the line on which it is. "xxx" can be any css color. The "smart" color is also recognized: green when the team is ahead or red when the team is late'
      icon: 'format-color-fill'
    ,
      key: '{behind/ahead}'
      description: 'If your are behind or late according to the burn down chart'
      icon: 'owl'
    ]
  render: (message, previousGoals, todaysGoals, sections, svg, useCid) ->
    message = angular.copy message
    message.body = renderTodaysGoals message.body, todaysGoals
    message.body = renderPreviousGoals message.body, previousGoals
    for key, value of sections
      message.body = renderSection message.body, key, value
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
    .then ->
      renderColor message
    .then (message) ->
      bdcBase64 = bdc.getPngBase64 svg
      renderBDC message, bdcBase64, useCid
    .then (message) ->
      renderTo message
    .then (message) ->
      renderCc message
