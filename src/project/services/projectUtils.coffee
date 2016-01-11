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
      value: 'Developer'
    ,
      label: 'Architect Developer'
      value: 'Architect Developer'
    ,
      label: 'Product Owner'
      value: 'Product Owner'
    ,
      label: 'Scrum Master'
      value: 'Scrum Master'
    ,
      label: 'Stakeholder'
      value: 'Stakeholder'
    ,
      label: 'Commercial'
      value: 'Commercial'
    ]
