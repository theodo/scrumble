request = require 'request'

module.exports = (Organization) -> return
  # config =
  #   TRELLO_KEY: process.env.TRELLO_KEY
  #   TRELLO_API_ENDPOINT: 'https://api.trello.com/1'
  #
  # Organization.fetch = (trelloOrganizationId) ->
  #   Organization.findOne
  #     where:
  #       remoteId: trelloOrganizationId
  #   .then (organization) ->
  #     return organization if organization?
  #
  #     request.get
  #       url: "#{config.TRELLO_API_ENDPOINT}/organizations/#{trelloOrganizationId}?key=#{config.TRELLO_KEY}&token=#{req.body.trelloToken}"
  #       json: true
  #     , (err, response, trelloInfo) ->
  #       return next err if err?
