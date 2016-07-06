angular.module 'Scrumble.settings'
.service 'Speed', (Project) ->
  promise = null

  lastSpeeds = (projectId) ->
    unless promise?
      promise = Project.getLastSpeeds(projectId).then (response) ->
        response.data
    return promise

  formattedSpeedInfo = (projectId) ->
    format = (speedInfo) -> "Sprint #{speedInfo.sprintNumber}: #{speedInfo.speed?.toFixed(1)}"
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
        .meanBy('speed')
        .toFixed(1)
      return null unless average?
      average
  {
    lastSpeeds
    formattedSpeedInfo
    average
  }
