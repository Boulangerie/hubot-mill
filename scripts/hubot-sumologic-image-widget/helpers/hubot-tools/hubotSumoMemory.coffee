_               = require 'lodash'
Promise         = require 'bluebird'
HubotTeleporter = require './hubotTeleporter'

class HubotSumoMemory
  constructor: () ->
    @FILENAME_TO_WATCH = "hubot-sumo-lesson"
    @FILETYPE_TO_WATCH = "JavaScript/JSON"
    @BRAIN_KEY = "hubot_sumo_memory"

  startLearning: () ->
    robot = HubotTeleporter.out()
    robot.adapter.client.ws.on "message", (data, flag) =>
      @watchKnowledge(data, flag)

  watchKnowledge: (data, flag) ->
    message = JSON.parse(data)
    if (@isKnowledgeFile(message))
      @fetchLesson(message.file.url_private_download)
        .then((fileContent) =>
          @learnNewTricks(fileContent)
        )

  isKnowledgeFile: (message) ->
    message.type is "file_shared" and
    message.file.name.indexOf(@FILENAME_TO_WATCH) >= 0 and
    message.file.pretty_type is @FILETYPE_TO_WATCH

  fetchLesson: (lessonUrl) ->
    new Promise((resolve, reject) =>
      HubotTeleporter
        .out()
        .http(lessonUrl)
        .header('Authorization', "Bearer #{process.env.HUBOT_SLACK_TOKEN}")
        .get() (err, res, body) ->
          try
            body = JSON.parse(body)
          catch e
            err = "Impossible to parse json file from slack"
          if err
            reject(err)
          else
            resolve(body)
    )

  learnNewTricks: (jsonKnowledge) ->
    memory = @getMemory()
    _.extend(memory, jsonKnowledge)
    @setMemory(memory)

  getMemory: () ->
    memory = HubotTeleporter
      .out()
      .brain.get @BRAIN_KEY
    
    if(_.isNull(memory))
      @eraseMemory()
      memory = {}

    return memory


  setMemory: (newMemory) ->
    HubotTeleporter
      .out()
      .brain.set @BRAIN_KEY, newMemory

  eraseMemory: () ->
    @setMemory({})

module.exports = new HubotSumoMemory()
