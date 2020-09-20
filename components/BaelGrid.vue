<template>
<div class="xs-text-6 md-text-5">
    <div v-if="items2[0]" class="r full-height browse" :style="`margin-top:${navbarheight}px`">

      <div v-if="items2[pi]" v-for="(p,pi) in items2" :key="p.pi" class="xs-border-right xs-border-bottom xs-p2 bcg-item" style="height:300px">
        <div class="item xs-full-height xs-flex xs-flex-column">
          <div style="height:65%">
            <img class="featured-image-small" :src="p.thumbnail" :alt="p.title" />
          </div>
          <div style="height:35%">
            <a v-if="p.directLink" :href="p.directLink" class="xs-text-center xs-flex xs-flex-align-center xs-full-height xs-flex-justify-center">
              <div>{{p.title}}</div>
            </a> 
            <nuxt-link v-else class="xs-text-center xs-flex xs-flex-align-center xs-full-height xs-flex-justify-center" :to="`${path(p)}`">
              <div>{{p.title}}</div>
            </nuxt-link>
          </div>
        </div>
      </div>

    </div>
    <div v-else class="r full-height browse">
      <div class="xs-p2 c-100 xs-flex xs-flex-align-center xs-flex-justify-center xs-text-center" :style="`height:calc(100vh - ${navbarheight}px);margin-top:${navbarheight}px`">

        
        <div v-if="total < 1 && !busy">No Results.</div>
      </div>

  </div>
  </div>
</template>

<script lang="coffee">
export default {
  props: ["items", "allitems"]
  data: ()->
    return {
      currentPage: null,
      pageNumbers: [],
      pageNumberCount: 0,
      items2: [],
      query: 1,
      busy: false,
      count: 0
    }
  methods:
    pageCheck: ()->
      if (this.allitems.length > 12)
        this.$store.commit("paginateOn", true);
        this.$store.commit("resultsLength", this.allitems.length);
      else if (this.allitems.length < 12)
        this.$store.commit("paginateOff", false);
      else
        this.$store.commit("paginateOff", false);

    loadMore: ()->
      this.count = this.offset;
      if (this.total > this.count && this.busy == false)
        this.busy = true
        this.items2.splice(0)
        for i in [0..11]
          api = this.allitems[this.count];

          this.items2.push(api);
          this.count++;
        this.busy = false;

    onResize: (event)->
      this.navHeight()

    navHeight: ()->
      if (process.browser)
        height = document.getElementById("navbar").clientHeight
        this.$store.commit("SET_NAVHEIGHT", height - 1)

    path: (post)->
      sportName = "/#{post.sport?.toLowerCase().replace(/ /g, "-")}-betting" or ""
      post._path.replace("/blog", sportName )

  watch:
    # whenever question changes, this function will run
    $route: ({ params, query })->
      if (this.$route.query.page > 1)
        this.loadMore();
        this.navHeight();
        this.pageCheck();
      else if (this.$route.query.page == null)
        this.$route.query.page = 1;
        this.loadMore();
        this.navHeight();
        this.pageCheck();
      else
        this.loadMore();
        this.navHeight();
        this.pageCheck();
    queryParam: ()->
      this.loadMore();

  computed:
    offset:()->
      if (this.queryParam > 1) then Number(this.queryParam - 1) * 12 else 0
    prevpage: ()->
      Number(this.queryParam) - 1;
    nextpage: ()->
      Number(this.queryParam) + 1;
    navbarheight: ()->
      this.$store.state.navheight;
    total: ()->
      this.allitems.length;

    queryParam: ()->
      if (this.$route.query.page == null) then 1 else Number(this.$route.query.page);

  updated:()->
    this.$nextTick(() =>
      this.pageCheck();
      this.navHeight();
      this.$store.commit("SET_GRIDOFFSET", this.offset);
    )
  mounted: ()->
    allitems = this.allitems
    console.log ({ allitems })
    if (process.browser)
      this.loadMore();

      this.$nextTick(() => 
        this.navHeight();
        this.pageCheck();
        window.addEventListener("resize", this.onResize);
      )
  beforeDestroy:()->
    # Unregister the event listener before destroying this Vue instance
    window.removeEventListener("resize", this.onResize);
};
</script>

<style scoped>
  a {
    font-size: 1.2rem;
    font-family: "Inconsolata", sans-serif;
    font-weight: 800;
    color: black;
    /* text-decoration-style: solid;
    text-decoration-line: underline;
    text-decoration-color: blueviolet;
    text-decoration-thickness: 10px; */
    border-bottom-color: deeppink;
    border-bottom-style: solid;
    border-bottom-width: 5px;
  }
  a:hover {
    color: deeppink;
  }
</style>
