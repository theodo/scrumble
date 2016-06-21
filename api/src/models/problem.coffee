loopback = require 'loopback'
createError = require 'http-errors'
Promise = require 'lodash'
moment = require 'moment'

module.exports = (Problem) ->
  # Problem.saveWithTags = -> (req) ->
  #   Problem.save(req.body).then (problem) ->
  #     Promise.all req.body.tags, (tag) ->
  #
  # Problem.remoteMethod 'saveWithTags',
  #   accepts: [
  #     { arg: 'req', type: 'object', http: { source: 'req' } }
  #   ]
  #   returns: { type: 'object', root: true }
  #   http: { verb: 'post', path: '/save-with-tags' }
