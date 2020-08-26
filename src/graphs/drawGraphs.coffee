import Chart from "chart.js"
import moment from "moment"

_colors = [
  'rgb(255,20,147)'
  'rgb(20,255,147)'
  'rgb(20,147,255)'
  'rgb(255,20,255)'
  'rgb(255,255,20)'
  'rgb(20,255,255)'
  'rgb(255,147,20)'
  'rgb(147,255,20)'
  'rgb(147,20,255)'
  'rgb(83,83,255)'
  'rgb(83,255,83)'
  'rgb(255,83,83)'
  'rgb(20,201,201)'
  'rgb(201,20,201)'
  'rgb(201,201,20)'
]

config = (rawData, mobileView, candidateNames, startDateTime=0, endDateTime=Infinity, colors=_colors)->
  color = Chart.helpers.color
  backgroundColor = (context)-> color(colors[context.datasetIndex]).alpha(0.5).rgbString()
  borderColor = (context)-> colors[context.datasetIndex]
  datasets = []

  for record in rawData when (not candidateNames? or record.name in candidateNames)
    datasets.push({
      label: record.name
      backgroundColor: backgroundColor
      borderColor: borderColor
      data: datum for datum in record.data when (datum.t >= startDateTime and datum.t <= endDateTime)
      type: 'line'
      pointRadius: 0
      fill: false
      lineTension: 0
      borderWidth: 2
    })
  {
    data:
      datasets: datasets
    options:
      animation:
        duration: 0
      scales:
        xAxes: [{
          type: 'time',
          distribution: 'series',
          offset: true,
          ticks:
            major:
              enabled: true,
              fontStyle: 'bold'
            source: 'data',
            autoSkip: true,
            autoSkipPadding: 75,
            maxRotation: 0,
            sampleSize: 100
            fontSize: if mobileView then 10 else 12
        }]
        yAxes: [{
          gridLines:
            drawBorder: false
          scaleLabel:
            display: true,
            labelString: 'Win chance %'
        }]
      legend:
        labels:
          boxWidth: if mobileView then 10 else 40
          fontSize: if mobileView then 8 else 12
      tooltips:
        intersect: false
        mode: 'index'
        bodyFontSize: if mobileView then 12 else 16
        callbacks:
          label: (tooltipItem, myData)->
            label = myData.datasets[tooltipItem.datasetIndex].label || ''
            if label
              label += ': '
            label += parseFloat(tooltipItem.value).toFixed(2) + "%"
            label
  }

export default {
  drawGraphs: ()->
    @.charts = @.charts or []
    @.chartData = @.chartData or {}
    mobileView = window?.innerWidth < 700
    console.log("getting graph eelemeentS")
    for graphEl in document.getElementsByName('brgraph')
      if (graphEl != null and not @.charts[graphEl.id]?)
        height = graphEl.height
        graphEl.height = height * 1.3 if mobileView
        onlyNames = graphEl.getAttribute('data-only-names')?.split(',')
        colors = graphEl.getAttribute('data-colors')?.split(',')
        dataStart = graphEl.getAttribute('data-start')
        dataFileName = graphEl.getAttribute('data-file-name')
        @.chartData[dataFileName] = await @.$axios.get("/data/#{dataFileName}") unless @.chartData[dataFileName]?
        data = @.chartData[dataFileName]?.data
        startDateTime = if dataStart? then moment(dataStart,"YYYY-MM-DD hh:mm").valueOf() else 0
        dataEnd = graphEl.getAttribute('data-end')
        endDateTime = moment(dataEnd,"YYYY-MM-DD hh:mm").valueOf() if dataEnd
        # graphEl.style.backgroundColor = 'rgb(0,0,0)'
        context = graphEl.getContext('2d')
        @.charts[graphEl.id] = new Chart(context, config(data, mobileView, onlyNames, startDateTime, endDateTime, colors))
}