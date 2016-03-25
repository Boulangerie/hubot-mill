_ = require 'lodash'

class PieFormatter
  constructor: (@name, @config, @rawData) ->
    @format(@rawData)

  getData: () ->
    return @data

  format: (rawData) ->
    @data = {
      chart:
        type: 'pie'
        forExport: true
        width: 600
        height: 400
      title:
        text: @name
      plotOptions:
        pie:
          dataLabels:
            enabled: false
          showInLegend: true
      series: @formatSeries(rawData)
    }

  #rawData is like raw.pie.json
  #Function goal format it like highchart.pie.js (series)
  formatSeries: (rawData) ->
    data = _(rawData.records)
      .chain()
      .mapValues('map')
      .map((v) ->
        newV = {}
        _.forIn(v, (v, k) ->
          if(_.startsWith(k, '_'))
            newV.y = _.parseInt(v)
          else
            newV.name = v
        )
        return newV
      )
      .toArray()
      .value()

    return [{
      name: ''
      colorByPoint: true,
      data: data
    }]

module.exports = PieFormatter