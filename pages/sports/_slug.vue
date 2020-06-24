<template>

  <BaelGrid :allitems="findSportPosts"></BaelGrid>
</template>

<script lang="coffee">
import BaelGrid from '~/components/BaelGrid'

export default {
  asyncData: ({ params, app, payload, route, store })->
    sport = await import("~/content/sports/" + params.slug + ".json");
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
    theSlug: ()-> this.$route.params.slug
   
  computed:
    findSportPosts: ()->
      post for post in this.$store.state.blogPosts when post.sport == this.name
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
