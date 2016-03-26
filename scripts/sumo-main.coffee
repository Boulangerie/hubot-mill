WidgetFinder    = require './hubot-sumologic-image-widget/widgetFinder'
GraphBuilder    = require './hubot-sumologic-image-widget/graphBuilder'
HubotTeleporter = require './hubot-sumologic-image-widget/helpers/hubotTeleporter'
sendToSlack     = require './hubot-sumologic-image-widget/sendToSlack'

module.exports = (robot) ->
  HubotTeleporter.enter(robot)

  robot.respond /sumo (.*)/i, (result) ->
    widget = new WidgetFinder(result.match[1], robot)
    if widget.exists()
      result.reply "Sure ! I process it and send you this one here !"
      widget
        .getData()
        .then((widgetData) ->
          GraphBuilder.generateSvgChart(widget.name, widget.config, widgetData)
        )
        .then(GraphBuilder.exportSvgToPng)
        .then(sendToSlack)
        .catch((e) ->
          robot.logger.error "Can't send the widget due to the following error"
          robot.logger.error e
        )
    else
      result.reply "I don't know this widget sorry... :disappointed:"


