_               = require 'lodash'
Promise         = require 'bluebird'
os              = require 'os'
fs              = Promise.promisifyAll(require('fs'))

#todo : Instead of using promise of folder, use it or
#       flag, this could avoid problem with promise
#       Other solution should be to create it at module install

class FileHelper
  constructor: () ->
    @DIR_PATH = "#{os.tmpdir()}/sumograph"
    @DIR_PROMISE = @createDir()

  write: (filename, data) ->
    filepath = @getPath(filename)
    @DIR_PROMISE
      .then(() ->
        fs.writeFileAsync(filepath, data)
      )
      .then(() ->
        return filename
      )
      .catch((error) ->
        return error
      )

  read: (filename) ->
    filepath = @getPath(filename)
    @DIR_PROMISE
      .then(() ->
        fs.readFileAsync(filepath)
      )

  getPath: (filename) ->
    return "#{@DIR_PATH}/#{filename}"

  #todo : Clean it ;)
  clean: () ->
    fs
    .readdirAsync(@DIR_PATH)
    .then((files) =>
      filesPromises = []
      console.log "Charts files will be deleted"
      _.forEach(files, (filename) =>
        console.log filename
        filesPromises.push(fs.unlinkAsync("#{@getPath(filename)}"))
      )
      Promise.all(filesPromises)
    )

  createDir: () ->
    fs
      .mkdirAsync(@DIR_PATH)
      .catch((error) =>
        if(error.code isnt 'EEXIST')
          return Promise.reject(error)
        else
          return Promise.resolve(true)
      )


module.exports = new FileHelper()
