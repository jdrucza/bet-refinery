<template>
  <div v-if="!signedUp">
    <div v-if="signingUp">
      <div>Just a tick while we sign you up...</div>
      <br/>
      <pulse-loader color="rgb(255,20,147" size="10px"></pulse-loader>
    </div>
    <form v-else @submit.prevent="processForm" action="/.netlify/functions/newsLetterSignup" name="mailinglist">
      <label><slot></slot></label>
      <input
        type="email"
        v-model="emaildata.email"
        class="text-input text-input--small xs-mb1 xs-mr2"
        placeholder="you@email.com"
      />
      <button type="submit" class="subscribe-button button--small">Subscribe</button>
    </form>
  </div>
  <div v-else>
    <div>Thanks for subscribing to our newsletter!</div>
  </div>
</template>

<script lang="coffee">
import PulseLoader from 'vue-spinner/src/PulseLoader.vue'
export default {
  components: {
    PulseLoader
  }
  mounted: ()->
    console.log { eBookFileName: @.eBookFileName }
  data: ()->
    {
      emaildata:
        email: ""
        eBookFileName: @.eBookFileName
      signingUp: false
    }
  props: [ 'axios', 'eBookFileName', 'store' ]
  methods:
    processForm: ()->
      @.signingUp = true
      try
        ajaxCaller = @.axios or @.$axios
        sendgrid = await ajaxCaller.post("#{process.env.API_URL}/.netlify/functions/newsLetterSignup", this.emaildata)
        store = @.store or @.$store
        store.dispatch('setSignedUp')
      catch e 
        console.log(e);
  computed:
    signupAboutSize: ()->
      {
        "c-25": this.signupBoolean,
        "c-4": !this.signupBoolean
      }
    signedUp: ()->
      store = @.store or @.$store
      store.state.signedUp
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

a {
  color: black;
  text-decoration-line: underline;
  text-decoration-color: deeppink;

  &:hover {
    color: deeppink;
  }
}
</style>
