angular.module 'Scrumble.problems'
.directive 'tagInput', ->
  restrict: 'E'
  templateUrl: 'problems/components/tag-input/template.html'
  scope:
    problem: '='
  controller: ($scope, TagRepository, Tag, $timeout) ->
    $scope.newTag = (label) ->
      label: TagRepository.format(label)

    $scope.createTag = (label) ->
      tag = Tag.new()
      tag.label = label
      Tag.findOrCreate(tag)

    $scope.problem?.inputTags = $scope.problem?.tags or []
