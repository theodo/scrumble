angular.module 'NotSoShitty.common'
.service 'dynamicFields', ->
  sprint = null
  project = null

  dict =
    '{sprintNumber}':
      value: -> sprint?.number
      description: 'Current sprint number'
      icon: 'cow'
    '{sprintGoal}':
      value: -> sprint?.goal
      description: 'The sprint goal (never forget it)'
      icon: 'target'
    '{speed}':
      value: ->
        if _.isNumber sprint?.resources?.speed
          sprint?.resources?.speed.toFixed 1
        else
          sprint?.resources?.speed
      description: 'Estimated number of points per day per person'
      icon: 'run'

  replaceToday = (text) ->
    text.replace /\{today#(.+?)\}/g, (match, dateFormat) ->
      moment().format dateFormat

  replaceYesterday = (text) ->
    text.replace /\{yesterday#(.+?)\}/g, (match, dateFormat) ->
      moment().subtract(1, 'days').format dateFormat

  # the service
  sprint: (_sprint_) ->
    sprint = _sprint_

  project: (_project_) ->
    project = _project_

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
    result

  render: (text) ->
    result = text or ''
    for key, elt of dict
      result = result.split(key).join(elt.value())

    # replace {today#YYYY-MM-DD}
    result = replaceToday result

    # replace {yesterday#YYYY-MM-DD}
    result = replaceYesterday result

    result
