<template>
  <div v-if="!sent">
    <!-- <slot></slot> -->
    <form @submit.prevent="processForm" action="/.netlify/functions/newsLetterSignup" name="mailinglist">
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
    Thanks for subscribing!
  </div>
</template>

<script lang="coffee">
export default {
  mounted: ()->
    console.log { eBookFileName: @.eBookFileName }
  data: ()->
    {
      emaildata:
        email: ""
        eBookFileName: @.eBookFileName
      sent: false
    }
  props: [ 'axios', 'eBookFileName' ]
  methods:
    processForm: ()->
      try
        ajaxCaller = @.axios or @.$axios
        sendgrid = await ajaxCaller.post("#{process.env.API_URL}/.netlify/functions/newsLetterSignup", this.emaildata)
        console.log("Processed!")
        this.sent = true
      catch e 
        console.log(e);
  computed:
    signupAboutSize: ()->
      {
        "c-25": this.signupBoolean,
        "c-4": !this.signupBoolean
      }
    # TODO add store field to check cookie for someone who's signed up already.
    # signupBoolean: ()->
    #   this.$store.state.siteInfo.emailsignup;
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
