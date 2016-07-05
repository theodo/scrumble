angular.module 'Scrumble.problems'
.service 'TagRepository', ->
  format: (label) ->
    _.kebabCase(label)
