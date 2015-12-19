angular.module 'NotSoShitty.common'
.service 'dynamicFields', ->
  promise = null
  sprint = null
  project = null

  dict =
    '{sprintNumber}': -> sprint.number

  init: ->
    promise = NotSoShittyUser.getCurrentUser().then (user) ->
      project = user.project
      project
    .then (project) ->
      Sprint.getActiveSprint(new Project project).then (_sprint_) ->
        sprint = _sprint_
