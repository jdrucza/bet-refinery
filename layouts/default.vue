<template>
  <section class="container xs-border xs-text-5 md-text-4">

    <BaelHeader :blogtitle="blogtitle" :thecrumb="this.$store.state.theCrumb" :posts="blogposts" />
    <nuxt/>
    <SlideOut/>
    <BaelFooter :pagination="paginate" />
    <modal name='e-book-prompt' :adaptive="true">
      <NewsLetterSignup e-book-file-name="Top Eight Sports Betting Mistakes - Bet Refinery.pdf" class='e-book-exit-prompt'>
        <h2>Wait! Wouldn't you like to win more?</h2>
        <br/>
        <br/>
        <br/>
        <p>Sign up to our newsletter to receive a free copy of our ebook</p>
        <p><b>'Top Eight Sports Betting Mistakes'.</b></p>
        <br/>
        <br/>
        <br/>
      </NewsLetterSignup>
    </modal>
  </section>
</template>
<script lang="coffee">
import SlideOut from "~/components/SlideOut"
import BaelFooter from "~/components/BaelFooter"
import BaelHeader from "~/components/BaelHeader"
import exitIntent from "exit-intent-mobile-bugfix"
import NewsLetterSignup from "~/components/NewsLetterSignup"

export default {
  data: ()->
    {
      email: { email: "" }
    }

  methods:
    navHeight: ()->
      if process.browser
        height = document.getElementById("navbar").clientHeight
        this.$store.commit("SET_NAVHEIGHT", height - 1)
    showEBookPrompt: ()->
      this.$modal.show('e-book-prompt')
    initExitIntent: ()->
      @.cancelExitIntent = exitIntent({
        showAgainAfterSeconds: 180
        maxDisplays: 3
        showAfterInactiveSecondsDesktop: 45
        onExitIntent: ()=>
          @.showEBookPrompt()
      })
  beforeCreate: ()->
    this.$store.dispatch('getCountry')
  updated: ()->
    if process.browser
      this.$nextTick(()=>
        this.navHeight()
        console.log(this.$store.state.navheight)
        console.log("default updated")
      )
  mounted: ()->
    if process.browser
      this.$nextTick(()=>
        this.navHeight()
        console.log("default mounted")
        # @.showEBookPrompt()
        @.initExitIntent()
      )
  beforeDestroy: ()->
    @.cancelExitIntent()
  computed:
    paginate: ()->
      this.$store.state.pagination
    blogposts: ()->
      this.$store.state.blogPosts
    blogtitle: ()->
      this.$store.state.blogTitle
  components: {
    SlideOut
    BaelHeader
    BaelFooter
    NewsLetterSignup
  }
}
</script>

<style lang="scss">
@import  "~tabulator-tables/dist/css/tabulator_midnight";
html,
body {
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  font-family: Montserrat, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
    Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
}
@media only screen and (max-width: 700px) {
  .main-title { font-size: 2rem !important; }
}
@media only screen and (min-width: 701px) {
  .main-title { font-size: 3rem !important; }
}
.main-title {
  font-family: "Inconsolata", sans-serif;
  font-weight: 600;
  line-height: 1;
}
.feat-wrapper {max-height:55vh;width:100%;}
.slide-left-enter,
.slide-right-leave-active {
  transform: translate(50%, 0);
  opacity:0;
  transition: all .25s;
}
.slide-left-leave-active,
.slide-right-enter {
  transform: translate(-50%, 0);
   opacity:0;
    transition: all .25s;

}
.slide-down-enter,
.slide-up-leave-active {
  transform: translate(0,50%);
  opacity:1;
  transition: all .25s;
}
.slide-down-leave-active,
.slide-up-enter {
  transform: translate(0,-50%);
   opacity:1;
    transition: all .25s;

}
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
  transition-delay: .3s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
.e-book-exit-prompt {
  display: block;
  padding: 30px;
  text-align: center;
}
</style>
