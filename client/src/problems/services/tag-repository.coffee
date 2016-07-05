angular.module 'Scrumble.problems'
.service 'TagRepository', (Tag) ->
  tagsPromise = null
  format: (label) ->
    _.kebabCase(label)
  getByPopularity: ->
    unless tagsPromise?
      tagsPromise = Tag.query(
        filter:
          order: 'counter DESC'
      )
    return tagsPromise
  resetCache: ->
    tagsPromise = null
