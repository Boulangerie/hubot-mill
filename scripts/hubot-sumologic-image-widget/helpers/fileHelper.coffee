_               = require 'lodash'
Promise         = require 'bluebird'
os              = require 'os'
fs              = Promise.promisifyAll(require('fs'))

class FileHelper
  constructor: () ->
    @GRAPH_DIR_PATH = "#{os.tmpdir()}/sumograph"
    @createGraphDir()


  readGraphFile: () ->

  writeGraphFile: () ->

  createGraphDir: () ->
    fs.mkdirAsync(@GRAPH_DIR_PATH, 0o666)
    .catch((error) =>
      if(error.code isnt 'EEXIST')
        return Promise.reject(error)
      else
        return Promise.resolve(true)
    )


module.exports = new FileHelper()
