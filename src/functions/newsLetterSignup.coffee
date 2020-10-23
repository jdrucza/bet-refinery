sgMail = require("@sendgrid/mail")
client = require("@sendgrid/client")

eBookData = require('./ebook').data

addSendgridRecipient = (client, email, countryCode)->
  console.log "adding recipient", { email, countryCode }
  new Promise((fulfill, reject) -> 
    data = {
      contacts: [
        {
          email: email
          country: countryCode
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
    countryCode = body.countryCode
    # welcomeEmail = event.queryStringParameters.welcome_email == "true"

    sgMail.setApiKey(SENDGRID_API_KEY)
    client.setApiKey(SENDGRID_API_KEY)
    console.log({
      client
      email
      SENDGRID_WELCOME_SENDER_EMAIL
      SENDGRID_WELCOME_SENDER_NAME
      SENDGRID_WELCOME_TEMPLATE_ID
      eBookFileName
    })
    addSendgridRecipient(client, email, countryCode)
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
        sgMail.send(
          to: ['jamesd@betrefinery.com', 'jamesm@betrefinery.com', 'jasonw@betrefinery.com']
          from: 'jamesd@betrefinery.com'
          subject: 'New Newsletter Subscriber!!'
          text: "#{email} from #{countryCode}"
        )
        callback(null, { statusCode: response.statusCode, body: email + " added" }) 
      )
      .catch((err)->callback(err, null))
    )
    .catch((err)-> callback(err, null))
}
