<template>
  <main>
    <div class="full-height single xs-border-left xs-border-right" :style="`min-height:calc(100vh - ${navbarheight}px);margin-top:${navbarheight}px`">
      <div class="xs-mt2 xs-p2 bcg-item">
        <div class="item xs-block xs-full-height">
          <div class="feat-wrapper" v-if="theThumb"><transition appear name="fade"><img class="featured-image" :src="thumbnail" :alt="title"></transition></div>
          <h1 class="xs-py3 main-title">{{title}}</h1>
          <no-ssr>
            <div class="xs-mt-5 bold">
            <ul class="list-unstyled xs-flex xs-flex-align-center">
             <li class="xs-inline-block xs-mr1" v-if="this.$store.state.theCategory"><div class="tag fill-gray-darker xs-border">
  <nuxt-link :to="`/category/${this.$store.state.theCategory.toLowerCase()}`" class="tag__link text-white">{{this.$store.state.theCategory}}</nuxt-link>
</div></li> 
<li class="xs-inline-block">{{ date }}</li>
              </ul> 
             </div>
          </no-ssr>
          <div class="xs-py3 post-content text-gray-lighter">
            <div v-html="$md.render(body)"></div>
          </div>
        </div>
      </div>

    </div>
  </main>
</template>



<script lang="coffee">
import MdWrapper from "~/components/MdWrapper"
import Chart from "chart.js"
import moment from "moment"
import neatCsv from "neat-csv"

export default {
  asyncData: ({ params, app, payload, route, store }) ->
    post = await import("~/content/blog/posts/" + params.slug + ".json");
   
    await store.commit("SET_TITLE", post.title);
    await store.commit("SET_DESCRIPTION", post.description);
    await store.commit("SET_SEO_TITLE", post.seoTitle);
    await store.commit("SET_THUMB", post.thumbnail);
    await store.commit("SET_CRUMB", 'Blog');
    await store.commit("SET_POSTCAT", post.category);
    await store.commit("paginateOff", false);
    post

  transition: (finish, start)->
    if start?  
      'slide-right'
    else
      'slide-left'

  head: ()->
    {
      title: this.seoTitle,
      meta: [
        { hid: 'description', name: 'description', content: this.description }
      ]
    }
  
  data: ()->
    {}

  methods:
    generateData: ()->
      randomNumber = (min, max)->
        return Math.random() * (max - min) + min

      randomBar = (date, lastClose)->
        open = randomNumber(lastClose * 0.95, lastClose * 1.05).toFixed(2)
        close = randomNumber(open * 0.95, open * 1.05).toFixed(2)
        return {
          t: date.valueOf()
          y: close
        }

      unit = 'day'

      date = moment('Jan 01 1990', 'MMM DD YYYY')
      now = moment()
      data = []
      for day in [1..600]
        date = date.clone().add(day, unit).startOf(unit)
        lastClose = if data.length > 0 then data[data.length - 1].y else 30
        data.push(randomBar(date, lastClose))

      data

    config: (rawData)->
      candidateData = {}
      for record in rawData
        candidateData[record.Name] = [] unless candidateData[record.Name]?
        datetime = moment(record.datetime, "DD/MM/YYYY hh:mm")
        candidateData[record.Name].push {t:datetime.valueOf(), y:record["Win %"]*100.0}

      color = Chart.helpers.color
      colors = [
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
      ]
      backgroundColor = (context)-> color(colors[context.datasetIndex]).alpha(0.5).rgbString()
      borderColor = (context)-> colors[context.datasetIndex]
      datasets = []

      # candidates = ['Trump','Biden','Muppet','Scumbag','Loser','Smith','Jones','Bad','Fugly']
      # for candidate in candidates
      #   datasets.push({
      #     label: candidate
      #     backgroundColor: backgroundColor
      #     borderColor: borderColor
      #     data: @.generateData()
      #     type: 'line'
      #     pointRadius: 0
      #     fill: false
      #     lineTension: 0
      #     borderWidth: 2
      #   })

      for cName, cData of candidateData
        datasets.push({
          label: cName
          backgroundColor: backgroundColor
          borderColor: borderColor
          data: cData
          type: 'line'
          pointRadius: 0
          fill: false
          lineTension: 0
          borderWidth: 2
        })
      console.log "datasets", datasets
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
              # afterBuildTicks: (scale, ticks)->
              #   console.log "scale, ticks", scale, ticks
              #   majorUnit = scale._majorUnit
              #   firstTick = ticks[0]

              #   val = moment(ticks[0].value)
              #   if ((majorUnit == 'minute' and val.second() == 0) or 
              #       (majorUnit == 'hour' and val.minute() == 0) or
              #       (majorUnit == 'day' and val.hour() == 9) or
              #       (majorUnit == 'month' and val.date() <= 3 and val.isoWeekday() == 1) or
              #       (majorUnit == 'year' and val.month() == 0))
              #     firstTick.major = true
              #   else
              #     firstTick.major = false
              #   lastMajor = val.get(majorUnit)

              #   for i in [1..ticks.length]
              #     tick = ticks[i-1]
              #     val = moment(tick.value)
              #     currMajor = val.get(majorUnit)
              #     tick.major = currMajor != lastMajor
              #     lastMajor = currMajor
              #   ticks
            }]
            yAxes: [{
              gridLines:
                drawBorder: false
              scaleLabel:
                display: true,
                labelString: 'Win chance %'
            }]
          tooltips:
            intersect: false,
            mode: 'index',
            callbacks:
              label: (tooltipItem, myData)->
                label = myData.datasets[tooltipItem.datasetIndex].label || ''
                if label
                  label += ': '
                label += parseFloat(tooltipItem.value).toFixed(2)
                label
      }

    onResize: (event)->
      @.navHeight()
      console.log(this.$store.state.navheight)
      console.log("slug resize")

    navHeight: ()->
      height = document.getElementById("navbar").clientHeight
      @.$store.commit("SET_NAVHEIGHT", height)

    drawGraph: ()->
      console.log("getting graph eelemeent")
      graphEl = document.getElementById('graph')
      console.log(graphEl)
      if (graphEl != null and not @.chart?)
        csv = await @.$axios.get('/data/Election_odds_record.csv')
        parsedData = await neatCsv(csv.data)
        # graphEl.style.backgroundColor = 'rgb(0,0,0)'
        context = graphEl.getContext('2d')
        console.log(context)
        @.chart = new Chart(context, @.config(parsedData))

  updated: ()->
    if process.browser
      this.$nextTick(() =>
        this.navHeight()
        console.log(this.$store.state.navheight)
        console.log("slug updated")
        this.drawGraph()
      )

  mounted: ()->
    if process.browser
      this.$nextTick(()=>
        this.navHeight()
        window.addEventListener("resize", this.onResize)
        console.log(this.$store.state.navheight)
        console.log("slug mounted")
      )
      # this.drawGraph()

  beforeDestroy: ()->
    # Unregister the event listener before destroying this Vue instance
    window.removeEventListener("resize", this.onResize)

  computed:
    theThumb: ()->
      return this.$store.state.theThumbnail

    allBlogPosts: ()->
      return this.$store.state.blogPosts

    navbarheight: ()->
      return this.$store.state.navheight

  components:
    MdWrapper
}
</script>
