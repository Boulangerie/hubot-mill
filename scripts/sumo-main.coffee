WidgetFinder = require './hubot-sumologic-image-widget/widgetFinder'

module.exports = (robot) ->
  new WidgetFinder("front-APIV1-error", robot)
