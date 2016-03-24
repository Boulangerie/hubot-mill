https       = require 'https'
fs          = require 'fs'
process     = require 'process'
FormData    = require 'form-data'
slackToken  = process.env.HUBOT_SLACK_TOKEN

sendToSlack = (filepath, room) ->
  form = new FormData()
  form.append('token', slackToken)
  form.append('file', fs.createReadStream(filepath))

  #@todo[jvi] : Make me pretty and smart !
  form.append('channels', "##{room}")

  #@todo[jvi] : Think to delete me
  console.log "Ready to slack it ! to #{room}"

  form.submit("https://slack.com/api/files.upload", (err, res) ->
    if err
      console.log err
    #@todo[jvi] : Think to delete me
    console.log "Freshly send to #{room}"
  )

module.exports = sendToSlack
