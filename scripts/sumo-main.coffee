WidgetFinder = require './hubot-sumologic-image-widget/widgetFinder'

module.exports = (robot) ->

  robot.respond /sumo (.*)/i, (result) ->
    argz = result.match[1].split(' ')
    n = argz.length
    # WARNING: Slack replaces "--" with "-" !
    # FIXME: do this with a regex

    verbose = false
    if argz.indexOf('-v') > -1
      verboseOptIndex = argz.indexOf('-v')
    else
      verboseOptIndex = argz.indexOf('-verbose')

    if verboseOptIndex > -1
      verbose = true
      argz.splice(verboseOptIndex, 1) # remove it from argz
      n = argz.length

    if argz.indexOf('-a') > -1
      addOptIndex = argz.indexOf('-a')
    else
      addOptIndex = argz.indexOf('—add')

    if addOptIndex > -1
      # add a widget to config
      argz.splice(addOptIndex, 1) # remove it from argz
      n = argz.length

      # DIRTY!!!
      # we should have --name "name" etc
      if n >= 4
        name = argz[0]
        dashboardId = argz[1]
        widgetId = argz[2]
        type = argz[3]

        result.reply "Ok, I'll remember the widget " + name + " (id " + widgetId + " - dashboardId " + dashboardId + " - type " + type + ")."
      else
        result.reply "To add a widget, I need 4 pieces of information!"

    else
      if n > -1
        widgetName = argz[n-1]
        widget = new WidgetFinder(widgetName, robot)
        if widget.exists()
          result.reply "I know this widget, let me grab it for you ;)"
          widget.getData(result.message)
        else
          result.reply "I don't know this widget sorry... :disappointed:"
