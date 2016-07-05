loopback = require 'loopback'
createError = require 'http-errors'
_ = require 'lodash'
Promise = require 'bluebird'

module.exports = (Tag) ->
  Tag.format = (label) ->
    _.kebabCase(label)

  Tag.findOrCreateCustom = (req) ->
    throw new createError.BadRequest() unless req?.body?.label?
    Tag.findOrCreate(
      where:
        label: Tag.format(req.body.label)
    ,
      label: Tag.format(req.body.label)
    )

  Tag.setProblemTags = (tags, problemId) ->
    Tag.app.models.TagInstance.destroyAll(problemId: problemId).then ->
      Promise.map tags, (tag) ->
        return unless _.isString tag.label
        Tag.findOne(
          where:
            label: Tag.format(tag.label)
        ).then (savedTag) ->
          return savedTag if savedTag?
          return Tag.create({label: Tag.format(tag.label), createdAt: new Date})
        .then (tag) ->
          Tag.app.models.TagInstance.create({tagId: tag.id, problemId: problemId})

  Tag.remoteMethod 'findOrCreateCustom',
    description: [ 'Find or Create a new Tag given its label' ]
    accepts: [
      { arg: 'req', type: 'object', http: { source: 'req' } }
      { arg: 'data', type: 'object', http: { source: 'body' } }
    ]
    returns: { type: 'object', root: true }
    http: { verb: 'PUT', path: '/' }
