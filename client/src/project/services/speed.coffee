angular.module 'Scrumble.settings'
.service 'Speed', (Project) ->
  promise = null

  lastSpeeds = (projectId) ->
    unless promise?
      promise = Project.getLastSpeeds(projectId)
    return promise

  formattedSpeedInfo = (projectId) ->
    format = (speedInfo) -> "Sprint #{speedInfo.number}: #{speedInfo.speed}"
    lastSpeeds(projectId).then (speedsInfo) ->
      _(speedsInfo)
        .filter((speedInfo) -> speedInfo.speed?)
        .map(format)
        .value()
        .join(', ')

  average = (projectId) ->
    lastSpeeds(projectId).then (speedsInfo) ->
      average = _(speedsInfo)
        .filter((speedInfo) -> speedInfo.speed?)
        .meanBy(speedsInfo, 'speed')
        .toFixed(1)
      return null unless average?

  {
    lastSpeeds
    formattedSpeedInfo
    average
  }
