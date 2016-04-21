WidgetFinder    = require './hubot-sumologic-image-widget/helpers/sumologic/widgetFinder'
GraphBuilder    = require './hubot-sumologic-image-widget/helpers/graphs/graphBuilder'
HubotTeleporter = require './hubot-sumologic-image-widget/helpers/hubot-tools/hubotTeleporter'
HubotSumoMemory = require './hubot-sumologic-image-widget/helpers/hubot-tools/hubotSumoMemory'
FileHelper      = require './hubot-sumologic-image-widget/helpers/utils/fileHelper'
sendToSlack     = require './hubot-sumologic-image-widget/helpers/utils/sendToSlack'

module.exports = (robot) ->
  HubotTeleporter.enter(robot)
  HubotSumoMemory.startLearning()

  robot.respond /lobotomize sumo/i, (result) ->
    HubotSumoMemory.eraseMemory()
    result.reply "Hubot forget his tricks about sumo :disappointed:"

  robot.respond /sumo (.*)/i, (result) ->
    widget = new WidgetFinder(result.match[1], robot)
    if widget.exists()
      result.reply "Sure ! I process it and send you this one here !"
      widget
        .getData()
        .then((widgetData) ->
          return GraphBuilder.generateSvgChart(widget.name, widget.config, widgetData)
        )
        .then((svgName) ->
          return GraphBuilder.exportSvgToPng(svgName)
        )
        .then((pngName) ->
          filePath = FileHelper.getPath(pngName)
          sendToSlack(filePath, result.message.user.room)
        )
        .then((result) ->
          console.log "result from sendToSlack : #{result}"
          console.log "Files will be cleaned"
          return FileHelper.clean()
        )
        .catch((e) ->
          result.reply "Something bad happen ! Seems I can't send you your graph :disappointed:"
          robot.logger.error "Can't send the widget due to the following error"
          robot.logger.error e
        )
    else
      result.reply "I don't know this widget sorry... :disappointed:"

