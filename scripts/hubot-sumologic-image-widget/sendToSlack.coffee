fs          = require 'fs'
process     = require 'process'
FormData    = require 'form-data'
Promise     = require 'bluebird'
slackToken  = process.env.HUBOT_SLACK_TOKEN

#@todo : Track activity / upgrade what is returned...
sendToSlack = (filepath, room) ->
  new Promise((resolve, reject) ->
    form = new FormData()
    form.append('token', slackToken)
    form.append('file', fs.createReadStream(filepath))

    #@todo[jvi] : Make me pretty and smart !
    form.append('channels', "##{room}")

    #@todo[jvi] : Think to delete me
    console.log "Ready to slack it ! to #{room}"

    form.submit("https://slack.com/api/files.upload", (err, res) ->
      if err
        reject(err)
      #send back more useful data
      resolve("Freshly send to #{room}")
    )
  )

module.exports = sendToSlack
