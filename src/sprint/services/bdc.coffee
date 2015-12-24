angular.module 'NotSoShitty.bdc'
.service 'bdc', ($q, trelloUtils) ->

  getPngBase64: (svg) ->
    img = new Image()
    serializer = new XMLSerializer()
    svgStr = serializer.serializeToString(svg)
    img.src = 'data:image/svg+xml;base64,' + window.btoa(svgStr)

    canvas = document.createElement 'canvas'
    document.body.appendChild canvas
    width = svg.offsetWidth
    height = svg.offsetHeight
    canvas.width = svg.offsetWidth
    canvas.height = svg.offsetHeight
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
            day.done = points
            break
        sprint.save().then ->
          deferred.resolve()
    else
      deferred.reject 'doneColumn is not set'

    deferred
