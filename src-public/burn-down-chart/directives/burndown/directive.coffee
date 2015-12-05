angular.module 'NotSoShitty.bdc'
.directive 'burndown', ->
  restrict: 'AE'
  scope:
    data: '='
  templateUrl: 'burn-down-chart/directives/burndown/view.html'
  link: (scope, elem, attr) ->
    maxWidth = 1000
    whRatio = 0.54

    [first, ..., last] = scope.data
    initialNumberOfPoints = last.standard

    computeDimensions = ->
      if window.innerWidth > maxWidth
        width = 800
      else
        width = (window.innerWidth - 80)
      height = whRatio * width
      if height + 128 > window.innerHeight
        height = window.innerHeight - 128
        width = height / whRatio
      config =
        width: width
        height: height
        margins:
          top: 20
          right: 70
          bottom: 30
          left: 50
        tickSize: 5
        color:
          standard: '#D93F8E' # default colors
          done: '#5AA6CB'
      config

    config = computeDimensions()
    bdcgraph = d3.select '#bdcgraph'

    window.onresize = ->
      config = computeDimensions()
      render scope.data, config

    render = (data, cfg) ->
      bdcgraph.select '*'
      .remove()

      # I recommend using a linear scale and computing the day number
      x = d3.time.scale().range([0, cfg.width])
      y = d3.scale.linear().range([cfg.height, 0])

      standardLine = d3.svg.line()
      .x (d, i) -> x(i)
      .y((d) -> y initialNumberOfPoints - d.standard)
      actualLine = d3.svg.line()
      .x (d, i) -> x(i)
      .y((d) -> y initialNumberOfPoints - d.done)

      x.domain [0, data.length]
      y.domain d3.extent data, (d) -> d.standard

      xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .ticks(data.length - 1)
      .tickFormat (d, i, j) ->
        return unless data[i]?
        dateFormat = d3.time.format '%A'
        dateFormat data[i].date

      yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      # display horizontal grids
      .innerTickSize(-cfg.width)
      .outerTickSize(0)

      chart = bdcgraph.append("svg")
      .attr("class", "chart")
      .attr("width", cfg.width + cfg.margins.left + cfg.margins.right)
      .attr("height", cfg.height + cfg.margins.top + cfg.margins.bottom)
      .append("g")
      .attr("transform", "translate(" + cfg.margins.left + "," + cfg.margins.top + ")")

      # define the shape of an arrowhead
      chart.append("defs").append("marker")
      .attr("id", "arrowhead")
      .attr("markerWidth", "12")
      .attr("markerHeight", "12")
      .attr("viewBox", "-6 -6 12 12")
      .attr("refX", "-2")
      .attr("refY", "0")
      .attr("markerUnits", "strokeWidth")
      .attr("orient", "auto")
      .append("polygon")
      .attr("points", "-2,0 -5,5 5,0 -5,-5")
      .attr("class", "arrowhead")

      addArrow = (selection) ->
        selection.selectAll('line')
        .attr('marker-end', (d, i) ->
          return if i > 0
          'url(#arrowhead)'
        )

      adjustTextLabels = (selection) ->
        selection.selectAll('text')
        .attr('transform', 'translate(0, 6)')

      #Create the x-axis
      chart.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + cfg.height + ")")
      .call(xAxis)
      .call(adjustTextLabels)
      .append("text")
      .attr('class', 'daily')
      .attr("transform", "translate(" + cfg.width + ", 25)")
      .attr("x", 20)
      .style("text-anchor", "end")
      .text("Daily meetings")

      #  Create the y-axis
      chart.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .call(addArrow)

      # Paint the standard line
      chart.append("path")
      .attr 'class', 'standard'
      .attr 'd', standardLine data
      .attr 'stroke', cfg.color.standard
      .attr 'stroke-width', 2
      .attr 'fill', 'none'

      # Paint the actual line
      chart.append("path")
      .attr 'class', 'done-line'
      .attr 'd', actualLine (d for d in data when d.done?)
      .attr 'stroke', cfg.color.done
      .attr 'stroke-width', 2
      .attr 'fill', 'none'


      chart.selectAll 'circle .standard-point'
      .data data
      .enter()
      .append 'circle'
      .attr 'class', 'standard-point'
      .attr 'cx', (d, i) -> x(i)
      .attr 'cy', (d) -> y initialNumberOfPoints - d.standard
      .attr 'r', 4
      .attr 'fill', cfg.color.standard


      chart.selectAll 'circle .done-point'
      .data (d for d in data when d.done?)
      .enter()
      .append 'circle'
      .attr 'class', 'done-point'
      .attr 'cx', (d, i) -> x(i)
      .attr 'cy', (d) -> y initialNumberOfPoints - d.done
      .attr 'r', 4
      .attr 'fill', cfg.color.done

      # this in order for svg to canvas to work
      d3.selectAll '.tick text'
      .attr 'font-size', '16px'
      #
      # drawValues = (color) ->
      #
      #   values = _.filter data, (d) ->
      #     return d.left? and d.standard? and d.diff?
      #
      #   vis.selectAll 'text .done-values'
      #   .data values
      #   .enter()
      #   .append 'text'
      #   .attr 'class', 'done-values'
      #   .attr 'font-size', '16px'
      #   .attr 'class', (d) ->
      #     if d.diff >= 0
      #       'good done-values'
      #     else
      #       'bad done-values'
      #   .attr 'x', (d, i) ->
      #     xRange i + 1
      #   .attr 'y', (d) ->
      #     - 10 + yRange(Math.max(d.standard, d.left))
      #   .attr 'fill', cfg.color.done
      #   .attr 'text-anchor', 'start'
      #   .text (d) ->
      #     if d.diff >= 0
      #       return '+' + d.diff.toPrecision(2) + ' :)'
      #     else
      #       return d.diff.toPrecision(2) + ' :('

    scope.$watch 'data', (data) ->
      return unless data
      render data, config
    , true
