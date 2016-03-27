Promise                     = require 'bluebird'
fs                          = Promise.promisifyAll(require('fs'))
_                           = require 'lodash'
svg2png                     = require 'svg2png'
StackedBarChart             = require '../graphs/stackedBarChart'
PieChart                    = require '../graphs/pieChart'
LinesChart                  = require '../graphs/linesChart'
TimecounterChart            = require '../graphs/timecounterChart'
CounterChart                = require '../graphs/counterChart'

class GraphBuilder
  constructor: () ->

  generateSvgChart: (chartName, config, widgetData) ->
    svg = @getChart(chartName, config, widgetData)
    #@todo[jvi] : Locate tmp file and use it instead of using __dirname
    svgPath = __dirname + "/#{chartName}.svg"

    fs.writeFileAsync(svgPath, svg)
      .then(() ->
        return svgPath
      , (error) ->
        return error
      )

  exportSvgToPng: (pathToSvg, pngName = "") ->
    #@todo[jvi] : Do better ?
    if (_.isEmpty(pngName))
      pathToPng = pathToSvg.replace('.svg', '.png')
    else
      tempName = pngName.split('/')
      tempName.pop()
      tempName.push('pngName')
      pathToPng = tempName.join('/')

    fs
      .readFileAsync(pathToSvg)
      .then(svg2png)
      .then((buffer) ->
        fs.writeFileAsync(pathToPng, buffer)
      )
      .then((results) ->
        return pathToPng
      )

  getChart: (name, config, widgetData) ->
    chart = {}
    if (config.type is "stackedBar")
      chart = new StackedBarChart(name, config, widgetData)
    else if (config.type is "pie")
      chart = new PieChart(name, config, widgetData)
    else if (config.type is "lines")
      chart = new LinesChart(name, config, widgetData)
    else if (config.type is "timecounter")
      chart = new TimecounterChart(name, config, widgetData)
    else if (config.type is "counter")
      chart = new CounterChart(name, config, widgetData)
    return chart.getSvg()

module.exports = new GraphBuilder()
