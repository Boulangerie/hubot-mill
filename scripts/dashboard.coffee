# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

getRandomItem = (items) => items[Math.floor(Math.random()*items.length)]

module.exports = (robot) ->

  getDashboardUrl = (id) => 'https://service.sumologic.com/ui/dashboard.html?f=' + id + '&t=d'
  allowCors = (res) =>
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,ApiSession")
    res.setHeader 'Access-Control-Allow-Credentials', true
    res.setHeader 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'

  robot.brain.data.dashboardurl = '140742254'

  robot.router.options '*', (req, res) ->
    res.status(200)
    allowCors(res)
    res.end()

  robot.router.get '/hubot/dashboard-url', (req, res) ->
    allowCors(res)
    res.json({
      url: getDashboardUrl(robot.brain.data.dashboardurl)
    })

  robot.hear /^dashboard$/, (res) ->
    res.send 'Dashboard URL is: ' + getDashboardUrl(robot.brain.data.dashboardurl) + "!"

  robot.hear /^dashboard (\d{6,10})$/, (res) ->
    robot.brain.data.dashboardurl = res.match[1] + ''
    res.send 'Dashboard URL changed to: ' + getDashboardUrl(robot.brain.data.dashboardurl) + "!"
