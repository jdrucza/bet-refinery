<template>

    <component :is="getLayout" :allitems="allBlogPosts"></component>
</template>

<script lang="coffee">
import BaelGrid from "~/components/BaelGrid";
import FullGrid from "~/components/FullGrid";
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
    {}
  methods: {}
  computed:
    allBlogPosts:()->
      postsAndPromotions = []
      currentPromotionIndex = 0
      promotions = @.$store.state.allPromotions
      for post in @.$store.state.blogPosts
        postsAndPromotions.push(post)
        if promotions.length > 0 and (postsAndPromotions.length % 5 == 4)
          postsAndPromotions.push(promotions[currentPromotionIndex])
          currentPromotionIndex++
          currentPromotionIndex = 0 if currentPromotionIndex == promotions.length
      # add a promotion to the end if none have been    
      postsAndPromotions.push(promotions[currentPromotionIndex]) if promotions.length > 0 and postsAndPromotions.length < 5
      postsAndPromotions
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
