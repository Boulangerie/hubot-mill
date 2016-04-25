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
      robot.logger.info "Sumo Graph : Start"
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
          sendToSlack(filePath, result.message)
        )
        .then((sended) ->
          robot.logger.info "File : #{sended.filepath} sended"
          robot.logger.info "to : #{sended.channel}/#{sended.room}"
          return FileHelper.clean()
        )
        .then(() ->
          robot.logger.info "All files clear ! Graph generation done !"
          robot.logger.info "Sumo Graph : End"
        )
        .catch((e) ->
          result.reply "Something bad happen ! Seems I can't send you your graph :disappointed:"
          robot.logger.error "Can't send the widget due to the following error"
          robot.logger.error e
          robot.logger.info "Sumo Graph : End"
        )
    else
      result.reply "I don't know this widget sorry... :disappointed:"
      robot.logger.info "Sumo Graph : End"

