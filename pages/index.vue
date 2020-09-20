<template>

    <component :is="getLayout" :allitems="allBlogPosts"></component>
</template>

<script lang="coffee">
import BaelGrid from "~/components/BaelGrid"
import FullGrid from "~/components/FullGrid"
import promotionFilter from "~/src/promotionFilter"
appliesToCountry = promotionFilter.appliesToCountry
export default {
  watchQuery: ['page'],
  transition: (end, start)-> 
    unless start?
      'fade' 
    else 
      if +end.query.page > +start.query.page then 'slide-right' else 'slide-left'
  name: "Index"
  components: { BaelGrid,FullGrid }
  data:()->
    {
      allBlogPosts: @.$store.getters.allBlogPosts
    }
  methods: {}
  computed:
    getLayout:()->
      if @.$store.state.siteInfo.altlayout == false
        'BaelGrid'
      else if @.$store.state.siteInfo.altlayout == true
        'FullGrid'
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
