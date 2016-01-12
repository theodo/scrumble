angular.module 'NotSoShitty.settings'
.service 'projectUtils', ->
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
  getRoles: ->
    [
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
  getDevTeam: (team) ->
    return [] unless _.isArray team
    _filter team, (member) ->
      member?.role?.value in ['dev', 'archi']
