import Vue from 'vue'
import Vuex from 'vuex'
import moment from 'moment'
import axios from 'axios'
import Cookies from 'js-cookie'
import promotionFilter from "~/src/promotionFilter"
appliesToCountry = promotionFilter.appliesToCountry

Vue.use(Vuex)

sortFunction = (p1,p2)->
  dateFormat = "dddd MMMM Do, YYYY";
  p2Date = moment(p2.date,dateFormat);
  p1Date = moment(p1.date,dateFormat);
  p2Date.diff(p1Date);

createStore = ()=>
  new Vuex.Store({
    state: ()-> 
      {
        menuIsActive: false,
        menuInitial: true,
        blogPosts: [],
        allPages: [],
        navheight: 60,
        blogTitle: '',
        siteInfo: [],
        connect: [],
        allTags: [],
        gridItems: [],
        gridNumPosts: '11',
        gridNumCats: '11',
        gridOffset: '0',
        theThumbnail: '',
        theCategory: '',
        theCrumb: '',
        allCats: [],
        allSports: [],
        allPromotions: [],
        results: [],
        resultsnum: [],
        pagination: false,
        description: '',
        seoTitle: '',
        country: '',
        signedUp: false
      }
    
    actions:
      nuxtServerInit: ({ dispatch })->
        await dispatch('getSiteInfo')
        await dispatch('getBlogPosts')
        await dispatch('getPages')
        await dispatch('getCats')
        await dispatch('getSports')
        await dispatch('getPromotions')
      
      getBlogPosts: ({ state, commit })->
        context = await require.context('~/content/blog/posts/', false, /\.json$/);
        searchposts = await context.keys().map((key) => 
          {
            context(key)...,
            _path: "/blog/#{key.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_POSTS', searchposts.sort(sortFunction))

      getPages: ({ state, commit })->
        context = await require.context('~/content/page/posts/', false, /\.json$/);
        pages = await context.keys().map((key) => 
          {
            context(key)...,
            _path: "/page/#{key.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_PAGES', pages)

      setGridNumPosts: ({ state, commit })->
        if (state.blogPosts > 12)
          this.$store.commit("SET_GRIDNUMPOSTS", 12)

      setGridNumCats: ({ state, commit })->
        if (state.allCats > 12)
          this.$store.commit("SET_GRIDNUMCATS", 12);

      getCats: ({ state, commit })->
        context = await require.context('~/content/categories/posts/', false, /\.json$/);
        pages = await context.keys().map((key)=>
          {
            context(key)...,
            _path: "/category/#{key.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_CATS', pages)

      getSports: ({ state, commit })->
        sportsFiles = await require.context('~/content/sports/', false, /\.json$/);
        sports = await sportsFiles.keys().map((fileName)=> 
          {
            sportsFiles(fileName)...,
            _path: "/sports/#{fileName.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_SPORTS', sports)

      getPromotions: ({ state, commit })->
        promotionsFiles = await require.context('~/content/promotions/', false, /\.json$/);
        promotions = await promotionsFiles.keys().map((fileName)=> 
          {
            promotionsFiles(fileName)...
            _path: "/promotions/#{fileName.replace('.json', '').replace('./', '')}"
            promotion: true
          }
        )
        commit('SET_PROMOTIONS', promotions.sort(sortFunction))

      getTags: ({ state, commit })->
        context = await require.context('~/content/tags/posts/', false, /\.json$/);
        pages = await context.keys().map((key) => 
          {
            context(key)...,
            _path: "/tagged/#{key.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_TAGS', pages)

      getSiteInfo: ({ state, commit })->
        info = require('~/content/setup/info.json');
        connect = require('~/content/setup/connect.json');
        context = require.context('~/content/blog/posts/', false, /\.json$/);

        searchposts = context.keys().map((key)=> 
          {
            context(key)...,
            _path: "/blog/#{key.replace('.json', '').replace('./', '')}"
          }
        )
        commit('SET_POSTS', searchposts)
        commit('SET_INFO', info)
        commit('SET_CONNECT', connect)

      getCountry: ({state, commit})->
        country = Cookies.get('country')
        if(not country? or country == 'undefined' )
          try
            response = await axios.get("https://ipapi.co/country/");
            country = response.data
            Cookies.set('country', country, { expires: 7 })
          catch e
            country = 'US'
        commit('SET_COUNTRY', country)

      getSignedUp: ({state, commit})->
        signedUp = false
        signedUpCookie = Cookies.get('signedUp')
        if(signedUpCookie? and not (signedUpCookie == 'undefined'))
          signedUp = true
        commit('SET_SIGNED_UP', signedUp)

      setSignedUp: ({state, commit})->
        Cookies.set('signedUp', 'true', { expires: 1000 })
        commit('SET_SIGNED_UP', true)

    getters:
      promotionsForCountry: (state, getters)->
       (promotion for promotion in state.allPromotions when appliesToCountry(promotion, state.country))
      allBlogPosts:(state, getters)->
        postsAndPromotions = []
        currentPromotionIndex = 0
        promotions = getters.promotionsForCountry
        for post in state.blogPosts
          postsAndPromotions.push(post)
          if promotions.length > 0 and (postsAndPromotions.length % 5 == 4)
            postsAndPromotions.push(promotions[currentPromotionIndex])
            currentPromotionIndex++
            currentPromotionIndex = 0 if currentPromotionIndex == promotions.length
        # add a promotion to the end if none have been    
        postsAndPromotions.push(promotions[currentPromotionIndex]) if promotions.length > 0 and postsAndPromotions.length < 5
        postsAndPromotions


    mutations:
      SET_POSTS: (state, data)->
        state.blogPosts = data
      SET_PAGES: (state, data)->
        state.allPages = data
      SET_CATS: (state, data)->
        state.allCats = data
      SET_SPORTS: (state, data)->
        state.allSports = data
      SET_PROMOTIONS: (state, data)->
        state.allPromotions = data
      SET_CRUMB: (state, data)->
        state.theCrumb = data
      SET_GRIDITEMS: (state, data)->
        state.gridItems = data
      SET_GRIDNUMPOSTS: (state, data)->
        state.gridNumPosts = data
      SET_GRIDNUMCATS: (state, data)->
        state.gridNumCats = data
      SET_GRIDOFFSET: (state, data)->
        state.gridOffset = data
      SET_POSTCAT: (state, data)->
        state.theCategory = data
      SET_TAGS: (state, data)->
        state.allTags = data
      SET_THUMB: (state, data)->
        state.theThumbnail = data
      SET_TITLE: (state, data)->
        state.blogTitle = data
      SET_DESCRIPTION: (state, data)->
        state.description = data
      SET_SEO_TITLE: (state, data)->
        state.seoTitle = data
      SET_NAVHEIGHT: (state, data)->
        state.navheight = data
      SET_INFO: (state, data)->
        state.siteInfo = data
      SET_CONNECT: (state, data)->
        state.connect = data
      SET_RESULTS: (state, data)->
        state.results = data
      SET_COUNTRY: (state, country)->
        state.country = country
      SET_SIGNED_UP: (state, signedUp)->
        console.log "Setting store.signedUp to ", signedUp
        state.signedUp = signedUp
      paginateOn: (state, data)->
        state.pagination = data
      paginateOff: (state, data)->
        state.pagination = data
      resultsLength: (state, data)->
        state.resultsnum = data
      setMenuState: (state, menuIsActive)->
        state.menuIsActive = menuIsActive

      toggleMenuState: (state)->
        state.menuIsActive = !state.menuIsActive
  })

export default createStore
