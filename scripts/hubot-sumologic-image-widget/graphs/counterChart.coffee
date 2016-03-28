_                 = require 'lodash'
SvgHelper         = require '../helpers/svgHelper'
counterTpl        = require './svgTpl/counter.tpl'
numeral           = require 'numeral'

class CounterChart
  constructor: (@name, @config, @rawData) ->
    @template = _.template(counterTpl)
    @variables = SvgHelper.getDimensions(@config)
    @svg = @template(_.merge(@variables, @format(@rawData)))

  getSvg: () ->
    @svg

  format: (rawData) ->
    field =  _.get(rawData, 'fields.0.name')
    value  = _.parseInt(_.get(rawData, "records.0.map.#{field}"))
    [fullNumber, shortNumber, metric] = numeral(value).format('0a').match(/([0-9]*)([a-zA-Z])$/)
    return {value : shortNumber, metric: metric}

module.exports = CounterChart
