<template>
  <nav ref="navBar" id="navbar" class="sm-border-bottom">
    <div class="r">

      <div class="c-4 xs-text-left xs-p2 sm-border-right">
        <div class="item">
          <nuxt-link class="sitename" to="/" exact>
            <img style="width:22px;height:22px;vertical-align:text-bottom;" v-if="this.$store.state.siteInfo.siteicon" :src="this.$store.state.siteInfo.siteicon">
            {{headerSiteName}}
          </nuxt-link>
        </div>
      </div>

      <div class="c-4 sm-border-top-none xs-border-bottom xs-border-top sm-border-bottom-none sm-border-right xs-p2">
        <div class="item xs-flex">
          <VueFuse placeholder="Search" :compResults="compResults" :keys="keys" :list="allPosts" event-name="searchChanged" />
        </div>

      </div>
      <div class="c-12 xs-p2 xs-text-6 titlebar sm-border-top xs-border-bottom sm-border-bottom-none">
        <div class="xs-flex sports-nav xs-flex-justify-space-between">
          <nuxt-link v-for="sport in allSports" :to="`${sportPath(sport)}`" :key="sport.name" exact>{{sport.name}}</nuxt-link>
          <nuxt-link v-for="post in headlinePosts" :to="`${postPath(post)}`" :key="post.title" exact>{{post.headlineTitle || post.title}}</nuxt-link>
          <!-- <nuxt-link to="/basketball" exact>Basketball</nuxt-link>
          <nuxt-link to="/us-election" exact>US election</nuxt-link>
          <nuxt-link to="/golf" exact>Golf</nuxt-link> -->
        </div>
      </div>
    </div>
  </nav>
</template>
<script lang="coffee">
import VueFuse from "~/components/VueFuse"
export default {
  props: ["blogtitle", "posts", "thecrumb"]
  data: ()->
    {
      results: []
      keys: [
        {
          name: "title"
          weight: 0.3
        },
        {
          name: "body"
          weight: 0.7
        }
      ],
      compResults: []
    }
  components: { VueFuse }
  computed:
    allSports: ()->
      @.$store.state.allSports
    headlinePosts: ()->
      post for post in @.$store.state.blogPosts when post.headline
    allPosts: ()->
      posts = this.$store.state.blogPosts
      pages = this.$store.state.allPages
      both = posts.concat(pages)
      both
    headerSiteName: ()->
      @.$store.state.siteInfo.sitename
    componentResults: ()->
      this.$store.state.results
     crumb: ()->
      this.$store.state.theCrumb

  methods:
    navHeight: ()->
      height = document.getElementById("navbar").clientHeight;
      console.log(height);
      this.$store.commit("SET_NAVHEIGHT", height - 1);
    sportPath: (sport)->
      sport._path.replace("/sports",'') + "-betting"
    postPath: (post)->
      sportName = "/#{post.sport?.toLowerCase().replace(/ /g, "-")}-betting" or ""
      post._path.replace("/blog",sportName)

  mounted: ()->
    @.$on("searchChanged", (results) =>  @.compResults = results)
}
</script>
<style>
#navbar {z-index:999;}
.titlebar .item {
  overflow-x: none;
}
.titlebar {
  background-color: black;
}
.results {
  padding-left: 0;
  transform: translateY(17px);
  width: 30vw;
}
.results li {
  list-style-type: none;
  margin-left: 0;
}
nav {
  position: fixed;
  background: white;
  top: 0;
  left: 0;
  right: 0;
}
nav a:hover { color: deeppink; }
.sitename {
  color: #000;
  font-family: "Inconsolata", sans-serif;
  text-transform: uppercase;
  font-weight: 800;
  font-size: 20px;
}
@media only screen and (max-width: 40rem) {
  .results {
    width: 94vw;
  }
}
.sports-nav > a {
  color: white;
  text-decoration-line: underline;
  text-decoration-color: deeppink;
  font-family: "Inconsolata", sans-serif;
  text-transform: uppercase;
  font-weight: 800;
  font-size: 18px;
}

.sports-nav > a:hover {
  color: deeppink;
}

</style>