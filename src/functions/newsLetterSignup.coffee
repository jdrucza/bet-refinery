# import data from "./ebook"
sgMail = require("@sendgrid/mail")
client = require("@sendgrid/client")

eBookData = require('./ebook').data

addSendgridRecipient = (client, email)->
  new Promise((fulfill, reject) -> 
    data = {
      contacts: [
        {
          email: email
        }
      ]
    }
    request = {
      method: "PUT"
      url: "/v3/marketing/contacts"
      body: data
    }

    console.log "ADDING RECIPIENT", { request, client }

    client.request(request).then(([response, body]) ->
      console.log "ADD RECIPIENT finished."
      console.log(response.statusCode)
      console.log({body})
      fulfill(response)
    ).catch((error)-> 
      console.log "ADD RECIPIEENT failed.", {error}
      reject(error)
    )
  )
sendWelcomeEmail = (client, email, senderEmail, senderName, templateID, eBookFileName)->
  new Promise((fulfill, reject) ->
    data = 
      from:
        email: senderEmail,
        name: senderName
      reply_to:
        email: senderEmail
      personalizations: [
        {
          to: [
            {
              email: email
            }
          ]
        }
      ]
      template_id: templateID
    if eBookFileName? and eBookFileName.length > 0
      console.log "Attaching EBOOK to email"
      data.attachments = [
        {
          content: eBookData
          filename: eBookFileName
          type: "application/pdf"
          disposition: "attachment"
        }
      ]

    request =
      method: "POST",
      url: "/v3/mail/send",
      body: data

    client.request(request).then(([response, body]) ->
      console.log "SEND WELCOME finished"
      console.log(response.statusCode);
      console.log(body);
      fulfill(response);
    ).catch((error)-> reject(error));
  )

module.exports = {
  handler: (event, context, callback)->
    {
      SENDGRID_API_KEY,
      SENDGRID_WELCOME_SENDER_EMAIL,
      SENDGRID_WELCOME_SENDER_NAME,
      SENDGRID_WELCOME_TEMPLATE_ID
    } = process.env
    body = JSON.parse(event.body)
    email = body.email
    eBookFileName = body.eBookFileName
    # welcomeEmail = event.queryStringParameters.welcome_email == "true"

    console.log { body, SENDGRID_API_KEY }

    sgMail.setApiKey(SENDGRID_API_KEY)
    client.setApiKey(SENDGRID_API_KEY)
    # sgMail.send(
    #   to: email
    #   from: 'jamesd@betrefinery.com'
    #   subject: 'Sending with Twilio SendGrid is Fun'
    #   text: 'and easy to do anywhere, even with Node.js'
    #   html: '<strong>and easy to do anywhere, even with Node.js</strong>'
    # )
    console.log({
      client
      email
      SENDGRID_WELCOME_SENDER_EMAIL
      SENDGRID_WELCOME_SENDER_NAME
      SENDGRID_WELCOME_TEMPLATE_ID
      eBookFileName
    })
    addSendgridRecipient(client, email)
    .then((response, body)->
      sendWelcomeEmail(
        client
        email
        SENDGRID_WELCOME_SENDER_EMAIL
        SENDGRID_WELCOME_SENDER_NAME
        SENDGRID_WELCOME_TEMPLATE_ID
        eBookFileName
      )
      .then((response)-> 
        callback(null, { statusCode: response.statusCode, body: email + " added" }) 
      )
      .catch((err)->callback(err, null))
    )
    .catch((err)-> callback(err, null))
    # console.log "WORLING!!"
    # callback(null, { statusCode: 200, body: "" })
}
