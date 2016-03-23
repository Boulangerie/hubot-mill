
class StackedBarFormatter
  constructor: (@name, @config, @rawData) ->
    @format(@rawData)

  getData: () ->
    return @data

  format: (rawData) ->
    @data = {
      chart:
        type: 'column'
        forExport: true
        width: 600
        height: 400
      title:
        text: @name
      xAxis:
        type: 'datetime'
        min: rawData.resolvedTimeRange.startMillis
        max: rawData.resolvedTimeRange.endMillis
      yAxis:
        min: 0
      plotOptions:
        column:
          stacking: 'normal'

    }
#    // For building series seems, Build an array for each fields[].keyField:false
#    // On each point, x should be keyField:true and y the value, then push to field array
#    series: [
#      {        //For each fields[].keyField:false
#      name: '404',
#      data: [{
#        x: 1458510720000,   //Directly usage from sumodata (ms)
#        y: 1                //Can be retr
#    },{
#    x: 1458510840000,
#    y: 4
#  },{
#    x: 1458510960000,
#    y: 4
#  },{
#    x: 1458511260000,
#    y: 5
#  },{
#    x: 1458511320000,
#    y: 6
#  }]
#    },
#    {
#      name: '403',
#      data: [{
#        x: 1458510720000,
#        y: 1
#      },{
#        x: 1458511260000,
#        y: 6
#      },{
#        x: 1458511320000,
#        y: 1
#      }]
#    }
#    ]
#  }

module.exports = StackedBarFormatter
