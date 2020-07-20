<template>
  <div class="zap-slideout xs-border xs-text-6 md-text-5" :class="{ isOpen: $store.state.menuIsActive  }">
    <div class="zap-slideout-opener">
      <div @click="toggle" class="hamburger hamburger--spin js-hamburger" :class="{'is-active': $store.state.menuIsActive }">
        <div class="hamburger-box">
          <div class="hamburger-inner"></div>
        </div>
      </div>
    </div>
    <ul class="zap-slideout-menu list-unstyled black-font">
      <li class="zap-slideout-menu-item">
        <nuxt-link style="color:#000" class="text-black black-font" to="/" exact>
        <img style="width:64px;" class="xs-block xs-fit xs-mb2" v-if="this.$store.state.siteInfo.siteicon  && this.$store.state.siteInfo.showmenu" :src="this.$store.state.siteInfo.siteicon" :alt="menuSiteName">
        {{menuSiteName}}
        </nuxt-link>
      </li>
      <li class="zap-slideout-menu-item--small">
        <nuxt-link to="/" exact>Home</nuxt-link>
      </li>
      <li v-if="myPages" v-for="(pg,i) in myPages" :key="`pg-${i}`" class="zap-slideout-menu-item--small">
        <nuxt-link :to="pg._path">{{pg.title}}</nuxt-link>
      </li>
      <li class="xs-mt5 zap-slideout-menu-item black-font">
        Sports
      </li>
      <li v-for="sport in allSports" :key="sport.name" class="zap-slideout-menu-item--small">
        <nuxt-link :to="sportPath(sport)">{{sport.name}}</nuxt-link>
      </li>
    </ul>
  </div>
</template>

<script lang="coffee">
export default {
  data: ()->
    { isOpen: false }
  computed: 
    allSports: ()->
      @.$store.state.allSports
    menuLinks: ()->
      @.$store.state.siteInfo.menu
    myPages: ()->
      @.$store.state.allPages
    menuSiteName: ()->
      @.$store.state.siteInfo.sitename
  methods:
    open: ()->
      @.isOpen = true
    close: ()->
      @.isOpen = false
    sportPath: (sport)->
      sport._path.replace("/sports",'') + "-betting"
    toggle: ()->
      # // Look for .hamburger
      @.$store.commit("toggleMenuState");

      hamburger = document.querySelector(".hamburger");
      # // On click

      # // Toggle class "is-active"

      if (@.isOpen) then @.close() else @.open()
}
</script>
  <style lang="scss">
.black-font {
  text-transform: uppercase;
  font-weight: 700;
}
.hamburger {
  padding: 15px 15px;
  display: inline-block;
  cursor: pointer;
  transition-property: opacity, filter;
  transition-duration: 0.15s;
  transition-timing-function: linear;
  font: inherit;
  color: inherit;
  text-transform: none;
  background-color: transparent;
  border: 0;
  margin: 0;
  overflow: visible;
}
.hamburger:hover {
  opacity: 0.7;
}

.hamburger-box {
  width: 40px;
  height: 24px;
  display: inline-block;
  position: relative;
}

.hamburger-inner {
  display: block;
  top: 50%;
  margin-top: -2px;
}
.hamburger-inner,
.hamburger-inner::before,
.hamburger-inner::after {
  width: 40px;
  height: 4px;
  background-color: #000;
  border-radius: 4px;
  position: absolute;
  transition-property: transform;
  transition-duration: 0.15s;
  transition-timing-function: ease;
}
.hamburger-inner::before,
.hamburger-inner::after {
  content: "";
  display: block;
}
.hamburger-inner::before {
  top: -10px;
}
.hamburger-inner::after {
  bottom: -10px;
}

.hamburger--spin .hamburger-inner {
  transition-duration: 0.22s;
  transition-timing-function: cubic-bezier(0.55, 0.055, 0.675, 0.19);
}
.hamburger--spin .hamburger-inner::before {
  transition: top 0.1s 0.25s ease-in, opacity 0.1s ease-in;
}
.hamburger--spin .hamburger-inner::after {
  transition: bottom 0.1s 0.25s ease-in,
    transform 0.22s cubic-bezier(0.55, 0.055, 0.675, 0.19);
}

.hamburger--spin.is-active .hamburger-inner {
  transform: rotate(225deg);
  transition-delay: 0.12s;
  transition-timing-function: cubic-bezier(0.215, 0.61, 0.355, 1);
}
.hamburger--spin.is-active .hamburger-inner::before {
  top: 0;
  opacity: 0;
  transition: top 0.1s ease-out, opacity 0.1s 0.12s ease-out;
}
.hamburger--spin.is-active .hamburger-inner::after {
  bottom: 0;
  transform: rotate(-90deg);
  transition: bottom 0.1s ease-out,
    transform 0.22s 0.12s cubic-bezier(0.215, 0.61, 0.355, 1);
}
.zap-slideout {
  position: fixed;
  right: 0;
  top: 0;
  width: 34vw;
  height: 100vh;
  z-index:1000;
  padding: 16px;
  background-color: #fff;
  transform: translate3D(100%, 0, 0);
  transition: transform 0.6s;

  &.isOpen {
    transform: translate3D(0, 0, 0);
    transition: transform 0.6s;
  }
}

.zap-slideout-opener {
  position: absolute;
  top: -4px;
  right: 100%;
  transform: scale(0.5);
  margin-right: 0px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #000;
  cursor: pointer;

  &:hover {
    text-decoration: underline;
  }
}

.zap-slideout-menu {
  font-weight: 600;
  transition: transform 1.6s ease(out-cubic);
}

.zap-slideout-menu-item,
.zap-slideout-menu-item--small {
  cursor: pointer;
  text-transform: uppercase;

  & + & {
    margin-top: 20px;
  }
}

.zap-slideout-menu-item {
  & + .zap-slideout-menu-item--small {
    margin-top: 30px;
  }
}

.zap-slideout-menu-item--small {
  font-weight: normal;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  a {
    color: black;
    text-decoration-line: underline;
    text-decoration-color: deeppink;

    &:hover {
      color: deeppink;
    }
  }
}

/* The famed Zap agency logo (TM) */
.zap-emoji {
  height: 120px;
}
</style>
