angular.module 'Scrumble.sprint'
.service 'bdc', ($q, trelloUtils, Sprint) ->

  getPngBase64 = (svg) ->
    img = new Image()
    serializer = new XMLSerializer()
    svgStr = serializer.serializeToString(svg)
    img.src = 'data:image/svg+xml;base64,' + window.btoa(svgStr)

    canvas = document.createElement 'canvas'
    document.body.appendChild canvas
    width = 800
    height = 800 * 0.54
    canvas.width = 800
    canvas.height = 800 * 0.54
    ctx = canvas.getContext '2d'
    ctx.fillStyle = 'white'
    ctx.fillRect 0, 0, width, height
    ctx.drawImage img, 0, 0, width, height
    result = canvas.toDataURL 'image/png'
    document.body.removeChild canvas

    result

  setDonePointsAndSave: (sprint) ->
    deferred = $q.defer()
    if sprint.doneColumn?
      trelloUtils.getColumnPoints(sprint.doneColumn).then (points) ->
        for day, i in sprint.bdcData
          unless day.done? or day.done == ''
            console.log points
            day.done = points
            break
        Sprint.save(sprint).then ->
          deferred.resolve()
    else
      deferred.reject 'DONE_COLUMN_MISSING'

    deferred.promise
  removeLastDoneAndSave: (sprint) ->
    for i in [sprint.bdcData.length - 1..0] by -1
      break if i is 0
      if sprint.bdcData[i].done?
        sprint.bdcData[i].done = null
        break
    Sprint.save(sprint)
  getPngBase64: getPngBase64
