_               = require 'lodash'
Promise         = require 'bluebird'
os              = require 'os'
fs              = Promise.promisifyAll(require('fs'))

#todo : Instead of using promise of folder, use it or
#       flag, this could avoid problem with promise

class FileHelper
  constructor: () ->
    @DIR_PATH = "#{os.tmpdir()}/sumograph"
    @DIR_PROMISE = @createDir()

  write: (filename, data) ->
    filepath = "#{@DIR_PATH}/#{filename}"
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
    filepath = "#{@DIR_PATH}/#{filename}"
    @DIR_PROMISE
      .then(() ->
        fs.readFileAsync(filepath)
      )
  
  #todo : Clean it ;)
  clean: () ->
    fs
    .readdirAsync(@DIR_PATH)
    .then((files) =>
      filesPromises = []
      console.log "Charts files will be deleted"
      _.forEach(files, (file) =>
        console.log file
        filesPromises.push(fs.unlinkAsync("#{@DIR_PATH}/#{file}"))
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
