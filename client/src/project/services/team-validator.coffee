angular.module 'Scrumble.settings'
.service 'TeamValidator', ['$mdDialog', ($mdDialog) ->
  hasTechTeam = (team) ->
    techRoles = ['dev', 'archi']
    _.intersection(techRoles, (member.role for member in team)).length > 0

  isValide: (team) ->
    if team.length is 0
      return 'EMPTY'
    unless hasTechTeam(team)
      return 'NO_TECH_TEAM'

    return true

  buildAlert: (cause) ->
    messages =
      EMPTY: 'Please select your team!'
      NO_TECH_TEAM: 'Please select at list one dev or archi dev in your team.'

    $mdDialog.alert()
      .clickOutsideToClose(true)
      .textContent(messages[cause])
      .ariaLabel('alert')
      .ok('Got it!')
]