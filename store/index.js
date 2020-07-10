import Vue from 'vue'
import Vuex from 'vuex'
import moment from 'moment'
Vue.use(Vuex)

const createStore = () =>
  new Vuex.Store({
    state: {
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
      results: [],
      resultsnum: [],
      pagination: false,
      description: '',
      seoTitle: ''
    },
    actions: {
      async nuxtServerInit({ dispatch }) {
        await dispatch('getSiteInfo')
        await dispatch('getBlogPosts')
        await dispatch('getPages')
        await dispatch('getCats')
        await dispatch('getSports')
      },
      
      async getBlogPosts({ state, commit }) {
        const context = await require.context('~/content/blog/posts/', false, /\.json$/);
        const searchposts = await context.keys().map(key => ({
          ...context(key),
          _path: `/blog/${key.replace('.json', '').replace('./', '')}`
        }));
        const sortFunction = function(p1,p2) {
          const dateFormat = "dddd MMMM Do, YYYY";
          const p2Date = moment(p2.date,dateFormat);
          const p1Date = moment(p1.date,dateFormat);
          return p2Date.diff(p1Date);
        }
        commit('SET_POSTS', searchposts.sort(sortFunction))
      },

      async getPages({ state, commit }) {
        const context = await require.context('~/content/page/posts/', false, /\.json$/);
        const pages = await context.keys().map(key => ({
          ...context(key),
          _path: `/page/${key.replace('.json', '').replace('./', '')}`
        }));
        commit('SET_PAGES', pages)
      },

      setGridNumPosts({ state, commit }) {
        if (state.blogPosts > 12) {
          this.$store.commit("SET_GRIDNUMPOSTS", 12);
        }
      },

      setGridNumCats({ state, commit }) {
        if (state.allCats > 12) {
          this.$store.commit("SET_GRIDNUMCATS", 12);
        }
      },

      async getCats({ state, commit }) {
        const context = await require.context('~/content/categories/posts/', false, /\.json$/);
        const pages = await context.keys().map(key => ({
          ...context(key),
          _path: `/category/${key.replace('.json', '').replace('./', '')}`
        }));
        commit('SET_CATS', pages)
      },

      async getSports({ state, commit }) {
        const sportsFiles = await require.context('~/content/sports/', false, /\.json$/);
        const sports = await sportsFiles.keys().map(fileName => ({
          ...sportsFiles(fileName),
          _path: `/sports/${fileName.replace('.json', '').replace('./', '')}`
        }));
        commit('SET_SPORTS', sports)
      },

      async getTags({ state, commit }) {
        const context = await require.context('~/content/tags/posts/', false, /\.json$/);
        const pages = await context.keys().map(key => ({
          ...context(key),
          _path: `/tagged/${key.replace('.json', '').replace('./', '')}`
        }));
        commit('SET_TAGS', pages)
      },

      getSiteInfo({ state, commit }) {
        const info = require('~/content/setup/info.json');
        const connect = require('~/content/setup/connect.json');
        const context = require.context('~/content/blog/posts/', false, /\.json$/);

        const searchposts = context.keys().map(key => ({
          ...context(key),
          _path: `/blog/${key.replace('.json', '').replace('./', '')}`
        }));
        commit('SET_POSTS', searchposts)
        commit('SET_INFO', info)
        commit('SET_CONNECT', connect)
      }
    },

    mutations: {
      SET_POSTS(state, data) {
        state.blogPosts = data
      },
      SET_PAGES(state, data) {
        state.allPages = data
      },
      SET_CATS(state, data) {
        state.allCats = data
      },
      SET_SPORTS(state, data) {
        state.allSports = data
      },
      SET_CRUMB(state, data) {
        state.theCrumb = data
      },
      SET_GRIDITEMS(state, data) {
        state.gridItems = data
      },
      SET_GRIDNUMPOSTS(state, data) {
        state.gridNumPosts = data
      },
      SET_GRIDNUMCATS(state, data) {
        state.gridNumCats = data
      },
      SET_GRIDOFFSET(state, data) {
        state.gridOffset = data
      },
      SET_POSTCAT(state, data) {
        state.theCategory = data
      },
      SET_TAGS(state, data) {
        state.allTags = data
      },
      SET_THUMB(state, data) {
        state.theThumbnail = data
      },
      SET_TITLE(state, data) {
        state.blogTitle = data
      },
      SET_DESCRIPTION(state, data) {
        state.description = data
      },
      SET_SEO_TITLE(state, data) {
        state.seoTitle = data
      },
      SET_NAVHEIGHT(state, data) {
        state.navheight = data
      },
      SET_INFO(state, data) {
        state.siteInfo = data
      },
      SET_CONNECT(state, data) {
        state.connect = data
      },
      SET_RESULTS(state, data) {
        state.results = data
      },
      paginateOn(state, data) {
        state.pagination = data
      },
      paginateOff(state, data) {
        state.pagination = data
      },
      resultsLength(state, data) {
        state.resultsnum = data
      },
      setMenuState(state, menuIsActive) {
        state.menuIsActive = menuIsActive
      },

      toggleMenuState(state) {
        state.menuIsActive = !state.menuIsActive
      },

    }
  })

export default createStore
