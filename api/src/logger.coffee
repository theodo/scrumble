moment = require 'moment'
nodemailer = require 'nodemailer'
smtpTransport = require 'nodemailer-smtp-transport'

if process.env.SMTP_HOST and process.env.SMTP_USER and process.env.SMTP_PASS and process.env.EMAIL_CONTACT
  smtpTransport = nodemailer.createTransport smtpTransport
    host : 'smtp.mailgun.org'
    secureConnection : false
    port: 587
    auth :
      user: 'postmaster@sandboxc57ee3cd15174479a4cbb190a16016aa.mailgun.org'
      pass: '1e6d200349ec37b81317c862cb7d24a3'
else
  smtpTransport = sendMail: -> return

module.exports =
  log: console.log
  error: console.error
  info: console.info
  warning: console.warn
  logRequest: (req) ->
    console.info "[#{moment().format()}][#{req.method}] #{req.originalUrl}"
  email: (subject, content, next) ->
    console.log "[#{moment().format()}][POST EMAIL] #{subject}"
    smtpTransport.sendMail
      from: 'alerts@scrumble.io'
      to: process.env.EMAIL_CONTACT
      subject: subject
      text: content
    , (er) ->
      if er
        console.error er
      next()
