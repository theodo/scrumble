angular.module 'Scrumble.sprint'
.service 'bdc', ['$q', 'trelloUtils', 'Sprint', ($q, trelloUtils, Sprint) ->

  getPngBase64 = (svg) ->
    $q (resolve) ->
      serializer = new XMLSerializer()
      svgStr = serializer.serializeToString(svg)

      img = new Image()
      img.onload = ->
        canvas = document.createElement('canvas')
        document.body.appendChild(canvas)
        width = 800
        height = 800 * 0.54
        canvas.width = width
        canvas.height = height
        ctx = canvas.getContext('2d')
        ctx.fillStyle =('white')
        ctx.fillRect(0, 0, width, height)
        ctx.drawImage(img, 0, 0, width, height)
        result = canvas.toDataURL('image/png')
        resolve(result)
        document.body.removeChild canvas
      img.src = 'data:image/svg+xml;base64,' + window.btoa(svgStr)

  setDonePointsAndSave: (sprint) ->
    deferred = $q.defer()
    if sprint.doneColumn?
      trelloUtils.getColumnPoints(sprint.doneColumn).then (points) ->
        for day, i in sprint.bdcData
          unless day.done? or day.done == ''
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
]