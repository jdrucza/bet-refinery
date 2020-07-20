<template>

  <BaelGrid :allitems="findSportPosts"></BaelGrid>
</template>

<script lang="coffee">
import BaelGrid from '~/components/BaelGrid'
import moment from "moment"

export default {
  asyncData: ({ params, app, payload, route, store })->
    sportName = params.sport.replace /-betting/, ''
    sport = await import("~/content/sports/" + sportName + ".json");
    console.log({sport})
    await store.commit("SET_TITLE", sport.seoTitle);
    # await store.commit("SET_CRUMB", 'Categories');
    return sport;
  head: ()->
    { title: this.seoTitle }
  components: {BaelGrid}
  transition: (end, start)->
    unless start
      'slide-right'
    else 
      +end.query.page > +start.query.page ? 'slide-right' : 'slide-left'
  data: ()->
    {}
  methods:
    theSlug: ()-> this.$route.params.sport
   
  computed:
    findSportPosts: ()->
      console.log "THIS:", @
      console.log "name:", @.name
      console.log "blogPosts", @.$store.state.blogPosts
      console.log "promotions", @.$store.state.allPromotions
      postsAndPromotions = []
      currentPromotionIndex = 0
      promotions = @.$store.state.allPromotions
      for post in this.$store.state.blogPosts when post.sport == this.name
        postsAndPromotions.push(post)
        if promotions.length > 0 and (postsAndPromotions.length % 5 == 4)
          postsAndPromotions.push(promotions[currentPromotionIndex])
          currentPromotionIndex++
          currentPromotionIndex = 0 if currentPromotionIndex == promotions.length
      postsAndPromotions.push(promotions[currentPromotionIndex]) if promotions.length > 0 # always add one to the end
      postsAndPromotions
}
</script>

<style>
.browse a {
  width: 100%;
}
.search:focus {
  outline: none;
}
.footer__heading {
  text-transform: uppercase;
}
nav .r {
  grid-gap: 0;
}
.r.full-height {
  grid-gap: 0;
}
@media only screen and (max-width: 40rem) {
  .xs-collapse {
    visibility: hidden;
    visibility: collapse;
    border: 0 !important;
    border-color: none !important;
    padding: 0 !important;
  }
  .xs-visible {
    visibility: visible;
  }
}
</style>
