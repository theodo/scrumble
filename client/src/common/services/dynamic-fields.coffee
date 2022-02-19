angular.module 'Scrumble.common'
.service 'dynamicFields', ['$q', 'trelloUtils', 'TrelloClient', 'sprintUtils', ($q, trelloUtils, TrelloClient, sprintUtils) ->

  dict =
    '{sprintNumber}':
      value: (sprint, project) -> sprint?.number
      description: 'Current sprint number'
      icon: 'cow'
    '{sprintGoal}':
      value: (sprint, project) -> sprint?.goal
      description: 'The sprint goal (never forget it)'
      icon: 'target'
    '{speed}':
      value: (sprint, project) ->
        if _.isNumber sprint?.resources?.speed
          sprint?.resources?.speed.toFixed 1
        else
          sprint?.resources?.speed
      description: 'Estimated number of points per day per person'
      icon: 'run'
    '{toValidate}':
      value: (sprint, project) ->
        if project?.columnMapping?.toValidate?
          trelloUtils.getColumnPoints project.columnMapping.toValidate
      description: 'The number of points in the Trello to validate column'
      icon: 'phone'
    '{blocked}':
      value: (sprint, project) ->
        if project?.columnMapping?.blocked?
          trelloUtils.getColumnPoints project.columnMapping.blocked
      description: 'The number of points in the Trello blocked column'
      icon: 'radioactive'
    '{done}':
      value: (sprint, project) ->
        if _.isArray sprint?.bdcData
          index = sprintUtils.getCurrentDayIndex sprint.bdcData
          done = sprint.bdcData[index]?.done
          if _.isNumber done then done.toFixed(1) else done
      description: 'The number of points in the Trello done column'
      icon: 'check'
    '{gap}':
      value: (sprint, project) ->
        if _.isArray sprint?.bdcData
          index = sprintUtils.getCurrentDayIndex sprint.bdcData
          diff = sprint.bdcData[index]?.done - sprint.bdcData[index]?.standard
          Math.abs(diff).toFixed 1
      description: 'The difference between the standard points and the done points'
      icon: 'tshirt-crew'
    '{total}':
      value: (sprint, project) ->
        if _.isNumber sprint?.resources?.totalPoints
          sprint.resources.totalPoints.toFixed(1)
      description: 'The number of points to finish the sprint'
      icon: 'cart'
    '{me}':
      value: (sprint, project) ->
        TrelloClient.get('/member/me').then (response) ->
          response.data.fullName
      description: 'Your fullname according to Trello'
      icon: 'account-circle'

  replaceToday = (text) ->
    text.replace /\{today#(.+?)\}/g, (match, dateFormat) ->
      moment().format dateFormat

  replaceYesterday = (text) ->
    text.replace /\{yesterday#(.+?)\}/g, (match, dateFormat) ->
      moment().subtract(1, 'day').format dateFormat

  replaceBehindAhead = (text, sprint) ->
    text.replace /\{ahead:(.+?) behind:(.+?)\}/g, (match, aheadColor, behindColor) ->
      isAhead = sprintUtils.isAhead sprint
      if isAhead
        return aheadColor
      else if isAhead?
        return behindColor
      else
        return aheadColor

  promises = null

  getAvailableFields: ->
    result = _.map dict, (value, key) ->
      key: key
      description: value.description
      icon: value.icon
    result.push
      key: '{today#format}'
      description: 'Today\'s date where format is a <a href="http://momentjs.com/docs/#/parsing/string-format/" target="_blank">moment format</a>'
      icon: 'clock'
    result.push
      key: '{yesterday#format}'
      description: 'Yesterday\'s date where format is a <a href="http://momentjs.com/docs/#/parsing/string-format/" target="_blank">moment format</a>. examples: EEEE for weekday, YYYY-MM-DD'
      icon: 'calendar-today'
    result.push
      key: '{ahead:value1 behind:value2}'
      description: 'Conditional value whether the team is behind or ahead according to the burndown chart. Example: &lt;span style=\'color:{ahead:green behind:red};\'&gt;{ahead:Ahead behind:Behind}: {gap} points&lt;/span&gt;'
      icon: 'owl'
    result.push
      key: '{bdc}'
      description: 'Display the burndown chart as an image'
      icon: 'trending-down'
    result

  ready: (sprint, project) ->
    promises = {}
    for key, elt of dict
      promises[key] = elt.value(sprint, project)

    # hack to pass the sprint data to the render function
    promises.__sprint = sprint

    $q.all(promises)

  render: (text, builtDict) ->
    result = text or ''

    for key, elt of builtDict
      result = result.split(key).join(elt)

    # replace {today#YYYY-MM-DD}
    result = replaceToday result

    # replace {yesterday#YYYY-MM-DD}
    result = replaceYesterday result

    # replace {ahead:value1 behind:value2}
    result = replaceBehindAhead result, builtDict.__sprint

    result
]