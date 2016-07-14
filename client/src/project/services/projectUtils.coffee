angular.module 'Scrumble.settings'
.service 'projectUtils', ($q, Project) ->
  currentProject = null
  roles = [
    label: 'Developer'
    value: 'dev'
  ,
    label: 'Architect Developer'
    value: 'archi'
  ,
    label: 'Product Owner'
    value: 'PO'
  ,
    label: 'Scrum Master'
    value: 'SM'
  ,
    label: 'Stakeholder'
    value: 'stakeholder'
  ,
    label: 'Commercial'
    value: 'com'
  ]
  getDailyRecipient: ->
    [
      label: 'no'
      value: 'no'
    ,
      label: 'cc'
      value: 'cc'
    ,
      label: 'to'
      value: 'to'
    ,
    ]
  getRoles: -> roles
  getDevTeam: (team) ->
    return [] unless _.isArray team
    _.filter team, (member) ->
      member?.role in ['dev', 'archi']
  getRoleLabel: (key) ->
    result = _.find roles, (role) ->
      role.value is key
    result?.label
  setCurrentProject: (project) ->
    currentProject = project
