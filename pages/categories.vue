<template>
  <BaelGrid :allitems="allCategories"></BaelGrid>
</template>

<script lang="coffee">
import BaelGrid from "~/components/BaelGrid"
export default {
  watchQuery: ["page"]

  asyncData: ({ params, app, payload, route, store }) -> 
    await store.commit("SET_TITLE", "Categories")

  transition: (finish, start) ->
    return "fade" unless start? 
    return  if +finish.query.page > +start.query.page then "slide-right" else "slide-left"

  components: { BaelGrid }

  data: ()->
    {}

  head: ->
    { title: "Categories | " + this.$store.state.siteInfo.sitename }

  computed:
    allCategories: ()->
      this.$store.state.allCats
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
