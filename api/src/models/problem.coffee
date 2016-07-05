_ = require 'lodash'

module.exports = (Problem) ->
  Problem.observe 'after save', (ctx, next) ->
    if _.isArray ctx.instance?.inputTags
      Tag = Problem.app.models.Tag
      return Tag.setProblemTags(ctx.instance.inputTags, ctx.instance.id)
    return next()
