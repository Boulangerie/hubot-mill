Promise                     = require 'bluebird'
os                          = require 'os'
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
    @GRAPH_DIR_PATH = "#{os.tmpdir()}/sumograph"

  generateSvgChart: (chartName, config, widgetData) ->
    svg = @getChart(chartName, config, widgetData)
    svgName = "#{chartName}.svg"
    svgPath = "#{@GRAPH_DIR_PATH}/#{svgName}"

    @createGraphDir()
      .then(
        console.log "Will write"
        fs.writeFileAsync(svgPath, svg)
      )
      .then(() ->
        return svgName
      )
      .catch((error) ->
        return error
      )

  exportSvgToPng: (svgName, pngName = "") ->
    svgPath = "#{@GRAPH_DIR_PATH}/#{svgName}"

    #@todo[jvi] : Do better ?
    if (_.isEmpty(pngName))
      pathToPng = svgPath.replace('.svg', '.png')
    else
      tempName = pngName.split('/')
      tempName.pop()
      tempName.push('pngName')
      pathToPng = tempName.join('/')

    console.log  "Export ready ?"
    @createGraphDir()
      .then(() ->
        fs.readFileAsync(svgPath)
          .then(svg2png)
          .then((buffer) ->
            fs.writeFileAsync(pathToPng, buffer)
          )
          .then((results) ->
            return pathToPng
          )
      )

  cleanCharts: () ->
    fs
      .readdirAsync(@GRAPH_DIR_PATH)
      .then((files) =>
        filesPromises = []
        console.log "Charts files will be deleted"
        _.forEach(files, (file) =>
          console.log file
          filesPromises.push(fs.unlinkAsync("#{@GRAPH_DIR_PATH}/#{file}"))
        )
        Promise.all(filesPromises)
      )

  createGraphDir: () ->
    fs.mkdirAsync(@GRAPH_DIR_PATH, 0o666)
      .catch((error) =>
        if(error.code isnt 'EEXIST')
          return Promise.reject(error)
        else
          return Promise.resolve(true)
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
