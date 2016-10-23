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
    Problem.query
      filter:
        where:
          projectId: $scope.project.id
        order: 'happenedDate DESC'
        include: 'tags'
    .then (problems) ->
      $scope.problems = problems
  loadProblems()

  generateMarkdown = (problems) ->
    $scope.markdown = markdownGenerator.problems(problems)

  $scope.update = (problems) ->
    loadProblems()
    generateMarkdown(problems)
