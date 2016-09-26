angular.module 'Scrumble.daily-report'
.controller 'SelectProblemsCtrl', (
  $scope
  $mdToast
  Problem
  markdownGenerator
) ->
  $scope.markdown = ''
  $scope.problems = []
  $scope.todaysProblems = []

  loadProblems = ->
    Problem.getWithOwnerAndCard projectId: $scope.project.id
    .then (problems) ->
      $scope.problems = problems
  loadProblems()

  generateMarkdown = (problems) ->
    $scope.markdown = markdownGenerator.problems(problems)

  $scope.update = (problems) ->
    loadProblems()
    generateMarkdown(problems)
