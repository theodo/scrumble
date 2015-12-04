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
          bottom: 20
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
      vis = bdcgraph.append 'svg'
      .attr 'width', cfg.width
      .attr 'height', cfg.height
      .append("g")
      .attr("transform", "translate(" + cfg.margins.left + "," + cfg.margins.top + ")")

      xScale = d3.time.scale()
  			.range([cfg.margins.left, cfg.width - cfg.margins.right]);
  		y = d3.scale.linear()
      		.range([
            cfg.margins.left
            cfg.width - cfg.margins.right
          ])
      xScale = d3.scale.linear()
      .range [
        cfg.margins.left
        cfg.width - cfg.margins.right
      ]
      .domain [0, data.length]

      yRange = d3.scale.linear()
      .range [
        cfg.height - cfg.margins.bottom
        cfg.margins.top
      ]
      .domain [-1, initialNumberOfPoints + 4]

      # AXIS
      xAxis = d3.svg.axis()
      .scale(xScale)
      .orient("bottom")
      .innerTickSize(-cfg.height)
      .outerTickSize(5)
      .tickPadding(10)
      .tickFormat (d, i, j) ->
        console.log d, i, j

      yAxis = d3.svg.axis()
      .scale yRange
      .orient("left")
      .innerTickSize(-cfg.width)
      .outerTickSize(5)
      .tickPadding(10)

      line = d3.svg.line()
      .x (d, i) -> xScale i
      .y (d) -> yRange initialNumberOfPoints - d.standard
      .interpolate 'linear'

      vis.append 'g'
      .attr 'class', 'x axis'
      .attr("transform", "translate(0," + cfg.height + ")")
      .call xAxis

      vis.append 'g'
      .attr 'class', 'y axis'
      .call yAxis

      vis.append 'path'
      .attr 'class', 'standard'
      .attr 'd', line data
      .attr 'stroke', cfg.color.standard
      .attr 'stroke-width', 2
      .attr 'fill', 'none'

      vis.selectAll 'circle .standard-point'
      .data data
      .enter()
      .append 'circle'
      .attr 'class', 'standard-point'
      .attr 'cx', (d, i) ->
        xScale i
      .attr 'cy', (d) ->
        yRange initialNumberOfPoints - d.standard
      .attr 'r', 4
      .attr 'fill', cfg.color.standard
      # this in order for svg to canvas to work
      # d3.selectAll '.tick text'
      # .attr 'font-size', '16px'

      # vis.append 'svg:path'
      # .attr 'class', 'axis'
      # .attr 'd', drawZero data
      # .attr 'stroke', cfg.color.done
      # .attr 'stroke-width', 1
      # .attr 'fill', 'none'

      # DRAW STANDARD
      drawStandardLine = (color) ->


        vis.append 'svg:path'
        .attr 'class', 'standard'
        .attr 'd', line data
        .attr 'stroke', color
        .attr 'stroke-width', 2
        .attr 'fill', 'none'



      # drawDoneLine = (color) ->
      #
      #   values = _.filter data, (d) ->
      #     return d.left?
      #   valuesArray = _.map values, (d) ->
      #     d.left
      #
      #   drawLine = d3.svg.line()
      #   .x (d, i) ->
      #     xRange i + 1
      #   .y (d) ->
      #     yRange d
      #   .interpolate 'linear'
      #
      #   vis.append 'svg:path'
      #   .attr 'class', 'done-line'
      #   .attr 'd', drawLine valuesArray
      #   .attr 'stroke', color
      #   .attr 'stroke-width', 2
      #   .attr 'fill', 'none'
      #
      #   vis.selectAll 'circle .done-point'
      #   .data values
      #   .enter()
      #   .append 'circle'
      #   .attr 'class', 'done-point'
      #   .attr 'cx', (d, i) ->
      #     xRange i + 1
      #   .attr 'cy', (d) ->
      #     return unless d.left?
      #     yRange d.left
      #   .attr 'r', 4
      #   .attr 'fill', cfg.color.done
      #
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

      # drawStandardLine cfg.color.standard
      # drawDoneLine cfg.color.done
      # drawValues()

    scope.$watch 'data', (data) ->
      return unless data
      render data, config
