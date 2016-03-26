jsdom                       = require 'jsdom'
createElementNSForHighchart = require './createElementNSForHighchart'

class HighchartsHelper
  constructor: () ->

  getNewPlayground: (chartData) ->
    doc = jsdom.jsdom('<!doctype html><html><body><div id="container"></div></body></html>')
    win = doc.defaultView
    doc.createElementNS = createElementNSForHighchart.bind({doc: doc})
    Highcharts = require('highcharts')(win)
    Highcharts.setOptions({
      plotOptions: {
        series: {
          animation: false,
          dataLabels: {
            defer: false
          }
        }
      }
    })

    Highcharts.chart('container', chartData)

    return win

module.exports = new HighchartsHelper()
