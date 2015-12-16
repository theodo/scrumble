angular.module 'NotSoShitty.bdc'
.service 'svgToPng', ->
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

    canvas.toDataURL 'image/png'
