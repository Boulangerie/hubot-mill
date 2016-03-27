_                 = require 'lodash'
SvgHelper         = require '../helpers/svgHelper'
counterTpl        = require './svgTpl/counter.tpl'

class CounterChart
  constructor: (@name, @config, @rawData) ->
    @template = _.template(counterTpl)
    @variables = SvgHelper.getDimensions(@config)
    @svg = @template(_.merge(@variables, @format(@rawData)))

  getSvg: () ->
    @svg

  format: (rawData) ->
    {value : 300, metric: 'K'}

module.exports = CounterChart
