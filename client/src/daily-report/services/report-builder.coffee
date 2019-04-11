angular.module 'Scrumble.daily-report'
.service 'reportBuilder', (
  $q
  Sprint
  Project
  trelloUtils
  dynamicFields
  sprintUtils
  bdc
)->
  converter = new showdown.Converter()

  renderBDC = (message, svg, useCid) ->
    bdc.getPngBase64(svg)
    .then (bdcBase64) ->
      src = if useCid then 'cid:bdc' else bdcBase64

      message.body = message.body.replace '{bdc}', "<img src='#{src}' />"
      if useCid
        message.cids = [ {
          type: 'image/png'
          name: 'BDC'
          base64: bdcBase64.split(',')[1]
          id: 'bdc'
        } ]
      message

  renderTo = (project) ->
    emails = (member.email for member in project.team when member.daily is 'to')
    _.filter emails

  renderCc = (project, copyCto = false) ->
    emails = (member.email for member in project.team when member.daily is 'cc')
   
    # Send a copy to the CTO if sprint is RED and ending soon.
    if copyCto
      emails.push 'maximet@theodo.fr'

    _.filter emails

  # If gap < 0 and end of sprint is in less than 2 days, returns true
  # Used to send a copy to the CTO
  shouldAddCto = (sprint) ->
    if _.isArray sprint?.bdcData
      index = sprintUtils.getCurrentDayIndex sprint.bdcData
      diff = sprint.bdcData[index]?.done - sprint.bdcData[index]?.standard
      Math.abs(diff).toFixed 1
      if diff > 0 # Sprint is ok, no need to send a copy to the CTO
        return false

      if sprint?.dates?.end
        if moment().diff(sprint.dates.end, 'days') < -2 # End of sprint is in more than 2 days
          return false

      return true


  _svg = null
  dynamicFieldsPromise = null
  prebuildMessage =
    to: null
    cc: null
    subject: null
    body: null
  render: (sections, dailyReport, svg, project, sprint) ->
    _svg = svg
    markdownMessage = ""
    for section in [
      'intro'
      'progress'
      'previousGoalsIntro'
      'previousGoals'
      'todaysGoalsIntro'
      'todaysGoals'
      'problemsIntro'
      'problems'
      'conclusion'
    ]
      continue unless _.isString sections[section]
      if _.includes section, 'Intro'
        if _.isEmpty sections[section.replace('Intro', '')]
          continue
      markdownMessage += sections[section] + "\n\n"
    htmlMessage = converter.makeHtml markdownMessage

    dynamicFieldsPromise = dynamicFields.ready sprint, project

    dynamicFieldsPromise.then (builtDict) ->
      prebuildMessage =
        to: renderTo project
        cc: renderCc project, shouldAddCto sprint
        subject: dynamicFields.render sections.subject, builtDict
        body: dynamicFields.render htmlMessage, builtDict

      renderBDC
        to: prebuildMessage.to
        cc: prebuildMessage.cc
        subject: prebuildMessage.subject
        body: prebuildMessage.body
      , svg, false
  buildCid: ->
    dynamicFieldsPromise.then (builtDict) ->
      renderBDC prebuildMessage, _svg, true
