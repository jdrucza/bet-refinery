siteInfo = require('./content/setup/info.json');
glob = require('glob');
path = require('path');

# Enhance Nuxt's generate process by gathering all content files from Netifly CMS
# automatically and match it to the path of your Nuxt routes.
# The Nuxt routes are generate by Nuxt automatically based on the pages folder.

#  Create an array of URLs from a list of files
#  @param {*} urlFilepathTable
getDynamicPaths = (urlFilepathTable)->
  [].concat(
    Object.keys(urlFilepathTable).map((url)->
      filepathGlob = urlFilepathTable[url];
      glob
        .sync(filepathGlob, { cwd: 'content' })
        .map((filepath)-> "#{url}/#{path.basename(filepath, '.json')}")
    )...
  )

sports = {}
for sportFilePath in glob.sync("content/sports/*.json")
  sport = require("./#{sportFilePath}") 
  sportFileName = path.basename(sportFilePath, '.json')
  sports[sport.name] = { sport..., fileName: sportFileName }

articleWithFileName = (articleFilePath, article)->
  articleFileName = path.basename(articleFilePath, '.json')
  { article..., fileName: articleFileName }

articles = []
for articleFilePath in glob.sync('content/blog/posts/*.json')
  article = require("./#{articleFilePath}")
  if article.sport?.length > 0
    articles.push(articleWithFileName(articleFilePath, article))

sportArticleUrl = (article)->
  "/#{sports[article.sport].fileName}-betting/#{article.fileName}"

sportArticlesUrls = (sportArticleUrl(article) for article in articles when sports[article.sport]?)

dynamicRoutes = getDynamicPaths({
  '/blog': 'blog/posts/*.json',
  '/page': 'page/posts/*.json',
  '/category': 'categories/posts/*.json',
  '/sports': 'sports/*.json',
  '/promotions': 'promotions/*.json',
  '/tagged': 'tags/posts/*.json'
})

dynamicRoutes = [dynamicRoutes..., sportArticlesUrls...]

module.exports = {
  mode: "universal",
  # ** Headers of the page
  transition: 
    mode: "in-out"
  env:
    API_URL: process.env.API_URL
  head:
    title: siteInfo.sitename
    meta: [
      { charset: 'utf-8' }
      { name: 'viewport', content: 'width=device-width, initial-scale=1' }
      { hid: 'description', name: 'description', content: siteInfo.sitedescription }
    ]
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;800&display=swap' }
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inconsolata:wght@300;400;600;800&display=swap' }
    ]
  css: ["@/assets/grid.css", "bf-solid/dist/solid.latest.css"]
  # icon:
  #   iconSrc: `${siteInfo.siteicon}`

  # ** Customize the progress bar color
  loading: 
    color: '#000000'
  modules: [
    '@nuxtjs/markdownit'
    '@nuxtjs/pwa'
    '@nuxtjs/axios'
    '@modules/coffeescript'
    '@nuxtjs/google-analytics'
    '@nuxtjs/gtm'
    'nuxt-facebook-pixel-module'
  ]
  googleAnalytics:
    id: 'UA-173154418-1'
  gtm:
    id: 'GTM-KBDFC9T'
  facebook:
    pixelId: '364714434869055'
    autoPageView: true
  markdownit:
    injected: true
    preset: 'default'
    breaks: true
    html: true
  manifest:
    name: siteInfo.sitename
    short_name: siteInfo.sitename
    description: siteInfo.sitedescription
    lang: 'en'
  workbox:
    runtimeCaching: [
      {
        urlPattern: '/images/uploads/.*'
        handler: 'cacheFirst'
        strategyOptions:
          cacheName: 'image-cache'
          cacheExpiration:
            maxEntries: 100,
            maxAgeSeconds: 86400
      }
    ]

  # ** Route config for pre-rendering
  router:
    scrollBehavior: (to, from, savedPosition) -> 
      return { x: 0, y: 0 }
    middleware: ['title']
  generate:
    routes: dynamicRoutes
  plugins: [
    '~/plugins/vuefuse'
    { src: "~/plugins/moment", ssr: false }
    { src: "~/plugins/lazyload", ssr: false }
    '~/plugins/vue-js-modal'
  ]
  # ** Build configuration
  build:
    extractCSS: true
    # ** Run ESLint on save
}
