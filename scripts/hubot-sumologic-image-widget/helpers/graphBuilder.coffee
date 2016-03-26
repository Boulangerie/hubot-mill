Promise                     = require 'bluebird'
fs                          = Promise.promisifyAll(require('fs'))
_                           = require 'lodash'
svg2png                     = require 'svg2png'
StackedBarChart             = require '../graphs/stackedBarChart'
PieChart                    = require '../graphs/pieChart'

class GraphBuilder
  constructor: () ->

  generateSvgChart: (chartName, config, widgetData) ->
    chart = @getChart(chartName, config, widgetData)
    svg = chart.document.getElementById('container').childNodes[0].innerHTML
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
        console.log results
        return pathToPng
      )

  getChart: (name, config, widgetData) ->
    chart = {}
    if (config.type is "stackedBar")
      chart = new StackedBarChart(name, config, widgetData)
    else if (config.type is "pie")
      chart = new PieChart(name, config, widgetData)
    return chart

module.exports = new GraphBuilder()
