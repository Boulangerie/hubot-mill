GraphBuilder  = require './graphBuilder'
mapping       = require './widget-mapping.json'
_             = require 'lodash'
sumoToken     = process.env.SUMOLOGIC_TOKEN || "ZnJvbnRlbmRAdGVhZHMudHY6RzhMZGNKdHVSTTh5IQ=="

class WidgetFinder
  constructor: (@name, @robot) ->
    @config = _.get(mapping, @name)
    if !_.isUndefined(@config)
      @getData()
    else
      robot.logger.error "This widget isn't mapped yet !"

  getData: () ->
    @robot
      .http("https://api.sumologic.com/api/v1/dashboards/#{@config.dashboardId}/data")
      .header('Authorization', "Basic #{sumoToken}")
      .get() (err, res, body) =>
        dashboardData = JSON.parse(body).dashboardMonitorDatas
        widgetData = _.find(dashboardData, {'id': @config.widgetId})
        if(!_.isUndefined(widgetData))
          graph = new GraphBuilder(@name, @config, widgetData)
          graph.generateChart()

module.exports = WidgetFinder
