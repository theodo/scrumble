angular.module 'Scrumble.problems'
.directive 'tagInput', ->
  restrict: 'E'
  templateUrl: 'problems/components/tag-input/template.html'
  scope:
    problem: '='
  controller: ($scope, TagRepository, Tag) ->
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
