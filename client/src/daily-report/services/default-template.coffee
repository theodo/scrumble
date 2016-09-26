angular.module 'Scrumble.daily-report'
.service 'defaultTemplates', ->
  getDefaultTemplate: (section) ->
    switch section
      when 'subject' then '[MyProject] Daily Report - Sprint {sprintNumber} - {today#YYYY-MM-DD}'
      when 'intro' then 'Hello,\n\nHere is the daily mail:'
      when 'progress' then '### Progress:\n\n**Sprint Goal: {sprintGoal}**\n\n- Done: {done} / {total} points\n- To validate: {toValidate} points\n- Blocked: {blocked} points\n- <span style=\'color:{ahead:green behind:red};\'>{ahead:Ahead behind:Behind}: {gap} points</span>\n\n{bdc}'
      when 'previousGoalsIntro' then '### Our previous goals:'
      when 'todaysGoalsIntro' then '### Our goals today:'
      when 'problemsIntro' then '### Problems:'
      when 'conclusion' then '### Useful links:\n\n- Trello: https://trello.com/...\n-Validation platform: ...\n-Production platform: ...\n\nHave a nice day.\nBest regards\n\n{me}\n\n*<span style=\'font-size: small;\'>This daily mail has been generated thanks to [Scrumble](http://theodo.github.io/scrumble)</span>*'
