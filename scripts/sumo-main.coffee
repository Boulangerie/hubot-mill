WidgetFinder = require './hubot-sumologic-image-widget/widgetFinder'

module.exports = (robot) ->

  robot.respond /sumo (.*)/i, (result) ->
    widget = new WidgetFinder(result.match[1], robot)
    if widget.exists()
      result.reply "Sure ! I process it and send you this one here !"
      widget.getData(result.message)
    else
      result.reply "I don't know this widget sorry... :disappointed:"


