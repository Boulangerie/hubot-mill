https       = require 'https'
fs          = require 'fs'
process     = require 'process'
FormData    = require 'form-data'
slackToken  = process.env.HUBOT_SLACK_TOKEN

sendToSlack = (filepath, channels) ->
  form = new FormData()
  form.append('token', slackToken)
  form.append('file', fs.createReadStream(filepath))
  form.append('channels', '#troll')

  console.log "Ready to slack it !"

  form.submit("https://slack.com/api/files.upload", (err, res) ->
    if err
      console.log err
    console.log "Freshly send to #{$channels}"
  )

module.exports = sendToSlack
