angular.module 'Scrumble.daily-report'
.controller 'SelectProblemsCtrl', (
  $scope
  $mdToast
  Problem
) ->
  $scope.problems = []
  $scope.todaysProblems = []

  loadProblems = ->
    Problem.query(
      filter:
        where:
          projectId: $scope.project.id
        order: 'happenedDate DESC'
        include: 'tags'
    ).then (problems) ->
      $scope.problems = problems
  loadProblems()

  generateMarkdown = (problems) ->
    unless _.isArray problems
      $scope.markdown = ""
      return
    $scope.markdown = _.chain problems
      .map (problem) ->
        check = problem.checkDate.toLocaleDateString('fr-FR').match(/(.+)\/.*/)[1]
        "#{problem.description}\n" +
        (if problem.link then "- Link: #{problem.link}\n" else "") +
        "- **Cause hypothesis** : #{problem.causeHypothesis}\n" +
        "- **Action** : #{problem.action}\n" +
        "- **Expected result #{check}** : #{problem.expectedResult}"
      .join "\n"
      .value()

  $scope.update = (problems) ->
    loadProblems()
    generateMarkdown(problems)
