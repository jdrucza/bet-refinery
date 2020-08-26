<template>
  <main>
    <div class="full-height single xs-border-left xs-border-right" :style="`min-height:calc(100vh - ${navbarheight}px);margin-top:${navbarheight}px`">
      <div class="xs-mt2 xs-p2 bcg-item">
        <div class="item xs-block xs-full-height">
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
import drawGraphs from "~/src/graphs/drawGraphs"
import showTables from "~/src/tables/showTables"

export default {
  asyncData: ({ params, app, payload, route, store }) ->
    console.log { params, app, payload, route, store }
    post = await import("~/content/blog/posts/" + params.article + ".json");
   
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
    onResize: (event)->
      @.navHeight()
      console.log(this.$store.state.navheight)
      console.log("article resize")

    navHeight: ()->
      height = document.getElementById("navbar").clientHeight
      @.$store.commit("SET_NAVHEIGHT", height)

    drawGraphs: drawGraphs.drawGraphs

    showTables: showTables.showTables

  updated: ()->
    if process.browser
      this.$nextTick(() =>
        this.navHeight()
        console.log(this.$store.state.navheight)
        console.log("article updated")
        @.drawGraphs()
        @.showTables()
      )

  mounted: ()->
    if process.browser
      this.$nextTick(()=>
        this.navHeight()
        window.addEventListener("resize", this.onResize)
        console.log(this.$store.state.navheight)
        console.log("component mounted")
      )
      # this.drawGraphs()

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
