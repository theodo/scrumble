angular.module 'Scrumble.daily-report'
.service 'markdownGenerator', () ->
  problems: (problems) ->
    unless _.isArray problems
      return ""
    _.chain problems
      .map (problem) ->
        check = problem.checkDate.toLocaleDateString('fr-FR').match(/(.+)\/.*/)[1]
        "#{problem.description}\n" +
        (if problem.link then "- Link: #{problem.link}\n" else "") +
        "- **Cause hypothesis** : #{problem.causeHypothesis}\n" +
        "- **Action** : #{problem.action}\n" +
        "- **Expected result #{check}** : #{problem.expectedResult}"
      .join "\n"
      .value()
  goals: (goals) ->
    unless _.isArray goals
      return ""
    goalsNames = ("- <span card-id='#{goal.id}'>" + goal.name + "</span>" for goal in goals)
    goalsNames.join "\n"
