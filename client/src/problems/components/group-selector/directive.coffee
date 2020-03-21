angular.module 'Scrumble.problems'
.directive 'groupSelector', ->
  restrict: 'E'
  templateUrl: 'problems/components/group-selector/template.html'
  scope: {}
  controller: ($scope, $stateParams, BoardGroup) ->
    $scope.selectedGroupId = $stateParams.boardGroupId or null
    BoardGroup.mine().then (groups) ->
      $scope.groups = groups

    $scope.groupChanged = (newGroupId) ->
      $scope.$emit 'boardGroup:selected', newGroupId
