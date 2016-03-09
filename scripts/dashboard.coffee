# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

class Dashboard
  # Static
  @SumologicToken: process.env.SUMOLOGIC_TOKEN || "ZnJvbnRlbmRAdGVhZHMudHY6RzhMZGNKdHVSTTh5IQ=="
  @sumoId: '140742254'
  @getSumoURLById: (id) -> 'https://service.sumologic.com/ui/dashboard.html?f=' + id + '&t=d'

  constructor: (@robot) ->
    @robot.brain.data.dashboard ?= {}
    @robot.brain.data.dashboard.urls ?= []
    @robot.brain.data.dashboard.sumologic ?= {
      lastUpdate: (new Date).getTime(),
      dashboards: []
    }

  getHistory: () => @robot.brain.data.dashboard.urls
  getCurrentUrl: () => @robot.brain.data.dashboard.urls[@robot.brain.data.dashboard.urls.length - 1]
  setCurrentUrl: (url) => @robot.brain.data.dashboard.urls.push(url)
  setDefault: () => @setCurrentUrl(Dashboard.getSumoURLById(Dashboard.sumoId))

  getSumologicDashboard: (done) ->
    @robot.http("https://api.sumologic.com/api/v1/dashboards")
      .header('Authorization', 'Basic ' + Dashboard.SumologicToken)
      .get() (err, res, body) =>
        dashboards = JSON.parse(body).dashboards
        @robot.brain.data.dashboard.sumologic.lastUpdate = (new Date).getTime()
        @robot.brain.data.dashboard.sumologic.dashboards = dashboards
        done(@robot.brain.data.dashboard.sumologic.dashboards)

  getSumologicDashboardData: (dashId) ->
#    @robot.http("https://api.sumologic.com/api/v1/dashboards/"+dashId+"/data")
    console.log dashId
    @robot.http("https://api.sumologic.com/api/v1/dashboards/"+dashId)
      .header('Authorization', 'Basic ' + Dashboard.SumologicToken)
      .get() (err, res, body) =>
#        dashboardData = JSON.parse(body).dashboardMonitorDatas
        dashboardData = JSON.parse(body)
        console.log JSON.stringify(dashboardData, null, 4)
#        @robot.brain.data.dashboard.sumologic.lastUpdate = (new Date).getTime()
#        @robot.brain.data.dashboard.sumologic.dashboards = dashboards
#        done(@robot.brain.data.dashboard.sumologic.dashboards)
#        done('Awesome I did the job !');


Util = require "util"
_ = require "lodash"
getRandomItem = (items) => items[Math.floor(Math.random()*items.length)]

module.exports = (robot) ->

  dashboard = new Dashboard(robot)

  displayHelp = """
                Dashboard URL manager
                `!dashboard set <url>` : Switch to given URL
                `!dashboard sumo <dashboardId>` : Switch to the dashboardId URL
                `!dashboard [-c|--current]` : Display current URL
                `!dashboard [-l|--list]` : List sumologic dashboard
                `!dashboard [-d|--default]` : Set default dashboard
                `!dashboard [-o|--old]` : Display history
                `!dashboard [-h|--help]` : Display this :D :troll:
                """

  robot.hear /^!dashboard$/i, (res) ->
    res.send displayHelp

  robot.hear /^!dashboard\s+(.*)$/i, (msg) ->
    if not msg.match[1]
      return msg.send displayHelp

    [key, value] = msg.match[1].split(" ")

    if key in ["-h", "--help"]
      msg.send(displayHelp)

    else if key in ["-l", "--list"]
      msg.send """
      O yes! You requested the sumo dashboard list :D
      _Check your DM_
      """
      dashboard.getSumologicDashboard((dashboards) =>
        dashboards.map((value) =>
          msg.send " - #{value.title} [#{value.id}] " + (if value.description then "_" + value.description + "_ " else "") + Dashboard.getSumoURLById(value.id)
        )
      )

    else if key in ["set"]
      msg.send(dashboard.setCurrentUrl(value))

    else if key in ["plop"]
      dashboard.getSumologicDashboardData(value)
      msg.send('Awesome !')

    else if key in ["sumo"]
      dashboard.setCurrentUrl(Dashboard.getSumoURLById(value))
      msg.send('Current url is now ' + dashboard.getCurrentUrl())

    else if key in ["-o", "--old"]
      msg.send('Last 10 url are:')
      dashboard.getHistory().reverse().map((value, key) =>
        if key <= 10
          msg.send('#' + key + ': ' + value)
      )

    else if key in ["-d", "--default"]
      dashboard.setDefault()
      msg.send('Hahaha, set to default sumologic user :D')

    else if key in ["-c", "--current"]
      msg.send(dashboard.getCurrentUrl())

  # Express routes
  allowCors = (res) =>
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,ApiSession")
    res.setHeader 'Access-Control-Allow-Credentials', true
    res.setHeader 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'

  robot.router.options '*', (req, res) ->
    res.status(200)
    allowCors(res)
    res.end()

  robot.router.get '/hubot/dashboard-url', (req, res) ->
    allowCors(res)
    res.json({
      url: dashboard.getCurrentUrl(),
      history: dashboard.getHistory()
    })
