_                 = require 'lodash'
SvgHelper         = require '../helpers/svgHelper'
timecounterTpl    = require './svgTpl/timecounter.tpl'

class TimecounterChart
  constructor: (@name, @config, @rawData) ->
    @template = _.template(timecounterTpl)
    @variables = SvgHelper.getDimensions(@config)
    @svg = @template(_.merge(@variables, @format(@rawData)))

  getSvg: () ->
    @svg

  format: (rawData) ->
    {value : 300, metric: 'ms'}


module.exports = TimecounterChart
