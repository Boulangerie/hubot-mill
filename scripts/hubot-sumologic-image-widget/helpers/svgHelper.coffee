jsdom                       = require 'jsdom'
fs                          = require 'fs'
svg2png                     = require 'svg2png'
pnfs                        = require 'pn/fs'
createElementNSForHighchart = require './createElementNSForHighchart'
sendToSlack                 = require './sendToSlack'
StackedBarFormatter         = require './graph-formatters/stackedBarFormatter'
PieFormatter                = require './graph-formatters/pieFormatter'

class SvgHelper
  constructor: (@name, @config, @widgetData) ->
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

    @Highcharts.chart('container', @formatData())

  generateSvgChart: (chartName) ->

  exportSvgToPng: (pathToSvg) ->



  generateChart: (message) ->
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
                #@todo[jvi] : Think to delete me
                console.log "File created : #{pngPath}"
                sendToSlack(pngPath, message.user.room)
              )
          )
      )
      .catch((e) ->
        console.error(e)
      )

  formatData: () ->
    data = {}
    if (@config.type is "stackedBar")
      data = new StackedBarFormatter(@name, @config, @widgetData).getData()
    else if (@config.type is "pie")
      data = new PieFormatter(@name, @config, @widgetData).getData()
    return data

module.exports = new SvgHelper()
