jsdom                       = require 'jsdom'
fs                          = require 'fs'
svg2png                     = require 'svg2png'
pnfs                        = require 'pn/fs'
createElementNSForHighchart = require './createElementNSForHighchart'
sendToSlack                 = require './sendToSlack'
StackedBarFormatter         = require './graph-formatters/stackedBarFormatter'

class GraphBuilder
  constructor: (@config, @widgetData) ->
    @doc = jsdom.jsdom('<!doctype html><html><body><div id="container"></div></body></html>')
    @win = @doc.defaultView
    @doc.createElementNS = createElementNSForHighchart.bind({doc: @doc})
    @Highcharts = require('highcharts')(@win)

    @chartData = @formatData()
    @initChart()

  initChart: () ->
    @Highcharts.setOptions({
      plotOptions: {
        series: {
          animation: false,
          dataLabels: {
            defer: false
          }
        }
      }
    })

    @Highcharts.chart('container', {
      chart: {
        type: 'column',
        forExport: true,
        width: 600,
        height: 400
      },
      title: {
        text: 'Stacked column chart'
      },
      xAxis: {
        type: 'datetime',
        min: 1458510705000,
        max: 1458511605000
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Number of errors'
        }
      },
      plotOptions: {
        column: {
          stacking: 'normal'
        }
      },

      series: [{
        name: '404',
        data: [{
          x: 1458510720000,
          y: 1
        }, {
          x: 1458510840000,
          y: 4
        }, {
          x: 1458510960000,
          y: 4
        }, {
          x: 1458511260000,
          y: 5
        }, {
          x: 1458511320000,
          y: 6
        }]
      }, {
        name: '403',
        data: [{
          x: 1458510720000,
          y: 1
        }, {
          x: 1458511260000,
          y: 6
        }, {
          x: 1458511320000,
          y: 1
        }]
      }]
    })

  generateChart: () ->
    svg = @win.document.getElementById('container').childNodes[0].innerHTML
    svgPath = __dirname + '/chart.svg'
    pngPath = __dirname + '/chart.png'

    pnfs
      .writeFile(svgPath, svg)
      .then(() ->
        pnfs
          .readFile(svgPath)
          .then(svg2png)
          .then((buffer) ->
            pnfs
              .writeFile(pngPath, buffer)
              .then(() ->
                console.log "File created : #{pngPath}"
                sendToSlack(pngPath)
              )
          )
      )
      .catch((e) ->
        console.error(e)
      )

  formatData: () ->
    data = {}
    if(@config.type is "stackedBar")
      data = new StackedBarFormatter(@config, @widgetData).format()
    return data

module.exports = GraphBuilder
