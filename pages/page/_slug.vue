<template>
  <main>
    <div class="full-height single xs-border-left xs-border-right" :style="`min-height:calc(100vh - ${navbarheight}px);margin-top:${navbarheight}px`">
      <div class="xs-mt2 xs-p2 bcg-item">
        <div class="item xs-block xs-full-height">
          <div v-if="thumbnail" class="fill-gray-lighter feat-wrapper"><transition appear name="fade"><img class="featured-image" :src="thumbnail" :alt="title"></transition></div>
          <h1 class="xs-py3 main-title">{{title}}</h1>
          <div class="xs-py3 post-content text-gray">
            <div v-html="$md.render(body)"></div>
          </div>
        </div>
      </div>

    </div>
  </main>
</template>



<script lang="coffee">
import Vue from 'vue'
import MdWrapper from "~/components/MdWrapper"
import NewsLetterSignup from "~/components/NewsLetterSignup"
import drawGraphs from "~/src/graphs/drawGraphs"
import showTables from "~/src/tables/showTables"

NewsLetterSignupComponent = Vue.extend(NewsLetterSignup)

export default {
  asyncData: ({ params, app, payload, route, store }) ->
    post = await import("~/content/page/posts/" + params.slug + ".json")
    console.log(post)
    await store.commit("SET_TITLE", post.title)
    await store.commit("SET_DESCRIPTION", post.description)
    await store.commit("SET_SEO_TITLE", post.seoTitle)
    
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
    onResize: (event)->
      @.navHeight()
      console.log(this.$store.state.navheight)
      console.log("article resize")

    navHeight: ()->
      height = document.getElementById("navbar").clientHeight
      @.$store.commit("SET_NAVHEIGHT", height)

    drawGraphs: drawGraphs.drawGraphs

    showTables: showTables.showTables
    updateOdds: showTables.updateOdds

    showNewsLetterSignups: ()->
      for signupEl in document.getElementsByName('brsignup')
        if signupEl? # for some reason the above was generating an undefined element, not sure how that's even possible...
          # TODO having to set axios feels a little hacky, try setting parent relationship 
          eBookFileName = signupEl.getAttribute('ebook-file-name')
          console.log { eBookFileName }
          instance = new NewsLetterSignupComponent({ propsData: { eBookFileName: eBookFileName, axios: @$axios, store: @$store } })
          instance.$slots.default = [ signupEl.innerHTML ]
          instance.$mount(signupEl)

  updated: ()->
    if process.browser
      this.$nextTick(() =>
        this.$store.commit("paginateOff", false);
        this.navHeight();
        console.log(this.$store.state.navheight);
        console.log("slug updated");
        @.drawGraphs()
        @.showTables()
        @.showNewsLetterSignups()
     )

  mounted: ()->
    if process.browser
      this.$nextTick(() =>
        this.navHeight()
        this.$store.commit("paginateOff", false)

        window.addEventListener("resize", this.onResize)
        console.log(this.$store.state.navheight)
        console.log("slug mounted")
      )

  beforeDestroy: ()->
    # Unregister the event listener before destroying this Vue instance
    window.removeEventListener("resize", this.onResize)

  computed:
    allBlogPosts: ()->
      return this.$store.state.blogPosts
    navbarheight: ()->
      return this.$store.state.navheight

  components: {
    MdWrapper
    NewsLetterSignup
  }
}
</script>
