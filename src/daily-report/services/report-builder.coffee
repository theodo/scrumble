angular.module 'Scrumble.daily-report'
.service 'reportBuilder', (
  $q
  ScrumbleUser
  Sprint
  Project
  trelloUtils
  dynamicFields
  sprintUtils
  bdc
)->
  converter = new showdown.Converter()

  renderBDC = (message, svg, useCid) ->
    bdcBase64 = bdc.getPngBase64 svg
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

  renderCc = (project) ->
    emails = (member.email for member in project.team when member.daily is 'cc')
    _.filter emails

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
        cc: renderCc project
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
