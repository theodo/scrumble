angular.module 'Scrumble.daily-report'
.service 'reportBuilder', ['$q','Sprint', 'Project', 'trelloUtils', 'dynamicFields', 'sprintUtils', 'bdc', (
  $q
  Sprint
  Project
  trelloUtils
  dynamicFields
  sprintUtils
  bdc
)->
  converter = new showdown.Converter()

  addImageInMessageCid = (message, type, name, base64, id) ->
    return (message.cids || []).concat([{type: type, name: name, base64: base64, id: id}])

  renderEmbeddedImages = (message, useCid) -> 
    images = message.body.match(/data:image\/(.*);base64,([^"]*)/gm)

    if images.length > 0
      for imageIndex of images
        match = /data:image\/(.*);base64,(.*)$/.exec(images[imageIndex])

        if match != null
          imageBase64 = match[0]
          imageType = match[1]

          src = if useCid then "cid:image#{imageIndex}" else imageBase64

          message.body = message.body.replace(imageBase64, src)

          if useCid
            message.cids = addImageInMessageCid(message, "image/#{imageType}", "Image #{imageIndex}", imageBase64.split(',')[1], "image#{imageIdx}")

    return message
    
  renderBDC = (message, svg, useCid) ->
    bdc.getPngBase64(svg)
    .then (bdcBase64) ->
      src = if useCid then 'cid:bdc' else bdcBase64

      message.body = message.body.replace '{bdc}', "<img src='#{src}' />"

      if useCid
        message.cids = addImageInMessageCid(message, 'image/png','BDC', bdcBase64.split(',')[1], 'bdc')
      return message
  
  renderImages = (message, svg, useCid) -> 
    renderEmbeddedImages(message, useCid)
    renderBDC(message, svg, useCid)

  renderTo = (project) ->
    emails = (member.email for member in project.team when member.daily is 'to')
    _.filter emails

  renderCc = (project, projectAtRisk) ->
    emails = (member.email for member in project.team when member.daily is 'cc')

    if projectAtRisk
      watchers = (member.email for member in project.team when member.daily is 'watcher')
      emails = emails.concat watchers unless watchers.length == 0

    _.filter emails

  # Given the full list of recipients, return true if there is at least
  # one theodo.fr email address.
  # This function is used to send a copy of the daily mail to the CTO of Theodo.fr
  # only if it is a theodo.fr project (Scrumble is used by other companies)
  isTheodoFrSprint = (emailAdresses) ->
    for email in emailAdresses
      if email.endsWith("theodo.fr")
        return true
    return false


  # If gap < 0 and end of sprint is in less than 2 days, returns true
  # Used to send a copy to the watchers (always CTO + watchers)
  isProjectAtRisk = (sprint) ->
    if _.isArray sprint?.bdcData
      index = sprintUtils.getCurrentDayIndex sprint.bdcData
      diff = sprint.bdcData[index]?.done - sprint.bdcData[index]?.standard
      Math.abs(diff).toFixed 1
      if diff >= 0 # Sprint is ok, no need to send a copy to the CTO
        return false

      if sprint?.dates?.end
        extraDay = if isLastDayAFullDay(sprint.resources.matrix) then -1 else 0
        if (moment().diff(sprint.dates.end, 'days') + extraDay) <= -2 # End of sprint is in more than 2 days
          return false

      return true
    return false

  # The last day in Scrumble might not be the day of the ceremony.
  # 
  # Case 1 : Ceremony is Friday at 9am
  # Team sets Thursday as the last day but Thursday is a full day of code.
  # returns true
  #
  # Case 2 : Ceremony is Friday at 11am
  # Team sets Friday as the last day but Friday is not a full day (only 2hours of code).
  # returns false
  #
  # How it works ?
  # Check if capacity of the team during the last day is over 0.5
  isLastDayAFullDay = (matrix) ->
    [..., lastDayCapacities] = matrix
    # For the last day not to be a full day, every member must have a capacity <= 0.5
    for capacity in lastDayCapacities
      if capacity > 0.5
        return true
    return false

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
      projectAtRisk = isProjectAtRisk sprint

      emailsTo = renderTo project
      emailsCc = renderCc project, projectAtRisk

      # Add TheodoFR scrumble watchers for Theodo.fr projects
      if projectAtRisk and isTheodoFrSprint(emailsTo.concat emailsCc)
        emailsCc.push 'watchscrumble@theodo.fr'

      prebuildMessage =
        to: emailsTo
        cc: emailsCc
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
      renderImages(prebuildMessage, _svg, true)
