angular.module 'Scrumble.daily-report'
.service 'defaultTemplates', ->
  getDefaultTemplate: (section) ->
    switch section
      when 'subject' then '[MyProject] Daily Mail - Sprint {sprintNumber} - {today#YYYY-MM-DD}'
      when 'intro' then 'Hello,\n\nHere is the daily mail:'
      when 'progress' then '### Progress:\n\n- Done: {done} / {total} points\n- To validate: {toValidate} points\n- Blocked: {blocked} points\n- <span style=\'color:{ahead:green behind:red};\'>{ahead:Ahead behind:Behind}: {gap} points</span>\n\n{bdc}'
      when 'previousGoalsIntro' then '### Our previous goals:'
      when 'todaysGoalsIntro' then '### Our goals today:'
      when 'problems' then '### Problems:'
      when 'conclusion' then 'Have a nice day.\nBest regards\n\n{me}\n\n*<span style=\'font-size: small;\'>This daily mail has been generated thanks to [Scrumble](http://theodo.github.io/scrumble)</span>*'
