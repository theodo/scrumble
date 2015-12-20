angular.module 'NotSoShitty.common'
.service 'dynamicFields', ($q, trelloUtils) ->
  sprint = null
  project = null

  getCurrentDayIndex = (bdcData) ->
    for day, i in bdcData
      return Math.max i-1, 0 unless day.done?

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
    '{toValidate}':
      value: ->
        if project?.columnMapping?.toValidate?
          trelloUtils.getColumnPoints project.columnMapping.toValidate
      description: ''
      icon: ''
    '{blocked}':
      value: ->
        if project?.columnMapping?.blocked?
          trelloUtils.getColumnPoints project.columnMapping.blocked
      description: ''
      icon: ''
    '{done}':
      value: ->
        if sprint?.bdcData?
          index = getCurrentDayIndex sprint.bdcData
          sprint.bdcData[index].done
      description: ''
      icon: ''
    '{gap}':
      value: ->
        if sprint?.bdcData?
          index = getCurrentDayIndex sprint.bdcData
          diff = sprint.bdcData[index].done - sprint.bdcData[index].standard
          Math.abs(diff).toFixed 1
      description: ''
      icon: ''
    '{total}':
      value: ->
        if _.isNumber sprint?.resources?.totalPoints
          sprint.resources.totalPoints
      description: ''
      icon: ''

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

    deferred = $q.defer()
    promises = {}
    for key, elt of dict
      promises[key] = elt.value()

    $q.all(promises).then (builtDict) ->
      for key, elt of builtDict
        result = result.split(key).join(elt)

      # replace {today#YYYY-MM-DD}
      result = replaceToday result

      # replace {yesterday#YYYY-MM-DD}
      result = replaceYesterday result

      deferred.resolve result
    .catch deferred.reject
    deferred.promise
