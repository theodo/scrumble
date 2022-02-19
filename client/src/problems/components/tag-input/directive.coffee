template = require './template.html'
require './style.less'

angular.module 'Scrumble.problems'
.directive 'tagInput', ->
  restrict: 'E'
  template: template
  scope:
    problem: '='
  controller: ['$scope', 'TagRepository', 'Tag', ($scope, TagRepository, Tag) ->
    $scope.newTag = (input) ->
      if _.isString input
        label: TagRepository.format(input)
      else
        input

    TagRepository.getByPopularity().then (tags) ->
      $scope.tags = tags

    $scope.createTag = (_tag_) ->
      tag = Tag.new()
      tag.label = _tag_.label
      Tag.findOrCreate(tag)

    $scope.problem?.inputTags = $scope.problem?.tags or []
  ]