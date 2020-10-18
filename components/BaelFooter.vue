<template>
  <footer class="fill-gray-lighter xs-text-6 md-text-5">
    <div class="r no-gap">
      <div class="c-12 xs-text-left xs-p2 xs-border">
        <div class="item xs-text-center">
          <div v-if="pagination" class="xs-flex xs-flex-justify-center xs-flex-align-center">
            <span class="xs-absolute xs-l1 xs-text-6 text-gray-lighter xs-mr2">
              <span class="bold">&nbsp; {{ 1 + this.$store.state.gridOffset}} - {{this.pageCount}}</span>
              of {{this.$store.state.resultsnum}}
            </span>

            <div class="pagination">
              <nuxt-link
                :to="`?page=${prevpage}`"
                tag="button"
                :class="{ 'pagination__button--disabled': this.prevpage <= 0 }"
                class="pagination__button pagination__button--prev"
              >
                <svg
                  class="pagination__button--prev-icon"
                  viewBox="0 0 512 512"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M368.619 16.892l24.485 24.449c2.938 2.934 4.897 7.335 4.897 11.246 0 3.912-1.959 8.313-4.897 11.246l-192.448 192.168 192.448 192.168c2.938 2.934 4.897 7.335 4.897 11.246 0 4.401-1.959 8.313-4.897 11.246l-24.485 24.449c-2.938 2.934-7.345 4.89-11.263 4.89s-8.325-1.956-11.263-4.89l-228.196-227.864c-2.938-2.934-4.897-7.335-4.897-11.246 0-3.912 1.959-8.313 4.897-11.246l228.196-227.864c2.938-2.934 7.345-4.89 11.263-4.89s8.325 1.956 11.263 4.89v.002z"
                  />
                </svg>
              </nuxt-link>
              <nuxt-link
                :to="`?page=${nextpage}`"
                no-prefetch
                tag="button"
                :class="{ 'pagination__button--disabled': this.queryParam >= this.totalpages }"
                class="pagination__button pagination__button--next"
              >
                <svg
                  class="pagination__button--next-icon"
                  viewBox="0 0 512 512"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M142.382 16.892l-24.485 24.449c-2.938 2.934-4.897 7.335-4.897 11.246 0 3.912 1.959 8.313 4.897 11.246l192.448 192.168-192.448 192.168c-2.938 2.934-4.897 7.335-4.897 11.246 0 4.401 1.959 8.313 4.897 11.246l24.485 24.449c2.938 2.934 7.345 4.89 11.263 4.89s8.325-1.956 11.263-4.89l228.196-227.864c2.938-2.934 4.897-7.335 4.897-11.246 0-3.912-1.959-8.313-4.897-11.246l-228.196-227.864c-2.938-2.934-7.345-4.89-11.263-4.89s-8.325 1.956-11.263 4.89v.002z"
                  />
                </svg>
              </nuxt-link>
            </div>

            <div></div>
          </div>
          <div v-else>&nbsp;</div>
        </div>
      </div>
      <div class="xs-text-left xs-p2 xs-border" :class="signupAboutSize">
        <div class="item">
          <div v-show="siteDescription" class="footer__heading xs-mb2">About</div>
          <p v-show="siteDescription">{{siteDescription}}</p>
        </div>
      </div>
      <div v-if="signupBoolean" class="c-25 xs-text-left xs-p2 xs-border">
        <div class="item">
          <div class="footer__heading xs-mb2">Newsletter Signup</div>
          <NewsLetterSignup></NewsLetterSignup>
        </div>
      </div>
      <div class="xs-text-left xs-p2 xs-border" :class="signupAboutSize">
        <div class="item">
          <div v-show="connectData" class="footer__heading xs-mb2">Connect</div>
          <ul class="list-unstyled">
            <li v-show="connectData" v-for="(c,i) in connectData" :key="i">
              <a :href="c.url">{{c.name}}</a>
            </li>
          </ul>
        </div>
      </div>
      <div class="xs-text-left xs-p2 xs-border" :class="signupAboutSize">
        <div class="item">
          <div class="footer__heading xs-mb2">Contact Us</div>

          <p>Want to get in touch with the guys about anything Bet Refinery?</p>
          <p>&larr; Send us an email.</p>

          <p>We are not currently looking for investment but please register your interest for future opportunities with the email above.</p>
        </div>
      </div>
      <div class="c-12 xs-text-left xs-p2 xs-border">
        <div class="item xs-text-6">BetRefinery Pty Ltd</div>
      </div>
    </div>
  </footer>
</template>

<script lang="coffee">
import NewsLetterSignup from "~/components/NewsLetterSignup"
export default {
  components: {
    NewsLetterSignup
  }
  props: ["pagination"]
  watchQuery: ['page']
  data: ()->
    {
      emaildata:
        email: ""
      sent: false
    }
  computed:
    nextCheck: ()->
      this.nextpage > this.queryParam
    pageCount: ()->
      tp = (this.$store.state.gridNumPosts * 1) + (this.$store.state.gridOffset * 1)
      if (tp > this.$store.state.resultsnum) then this.$store.state.resultsnum  else tp + 1
    signupAboutSize: ()->
      {
        "c-25": this.signupBoolean,
        "c-4": !this.signupBoolean
      }
    prevpage: ()->
      Number(this.queryParam) - 1
    totalpages: ()->
      Math.ceil(this.$store.state.resultsnum / 12)
    nextpage: ()->
      Number(this.queryParam) + 1
    queryParam: ()->
      if @.$route.query.page? then Number(this.$route.query.page) else 1
    connectData: ()->
      this.$store.state.connect.connectlinks
    siteDescription: ()->
      this.$store.state.siteInfo.sitedescription;
    signupBoolean: ()->
      this.$store.state.siteInfo.emailsignup;
    signedUp: ()->
      @.$store.state.signedUp
}
</script>

<style lang="scss" scoped>
.subscribe-button {
  color: white;
  background-color: deeppink;
}
.text-input {
  max-width: 100%;
}

.footer__heading {
  max-width: 100%;
}
a {
  color: black;
  text-decoration-line: underline;
  text-decoration-color: deeppink;

  &:hover {
    color: deeppink;
  }
}
</style>
