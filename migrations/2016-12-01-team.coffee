_ = require('underscore')
Parse = require('parse/node').Parse
Parse.initialize 'UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG', 'c8v3Y5mg7VEnNN5u1encLS1GKqsqEWC1vZOYLmQb', 'yLM0zIxaICtwlpPtp4YokCQwo1Z3WrESzH44GzN6'
Parse.Cloud.useMasterKey()

roles =
  'Developer':
    label: 'Developer'
    value: 'dev'
  'Architect Developer':
    label: 'Architect Developer'
    value: 'archi'
  'Product Owner':
    label: 'Product Owner'
    value: 'PO'
  'Scrum Master':
    label: 'Scrum Master'
    value: 'SM'
  'Stakeholder':
    label: 'Stakeholder'
    value: 'stakeholder'
  'Commercial':
    label: 'Commercial'
    value: 'com'

query = new (Parse.Query)('Project')
query.equalTo "name", "Test Not So Shitty"
query.each (project) ->
  console.log 'Updating object: ' + project.id

  oldTeam = project.get 'team'
  newTeam = _.union oldTeam.dev, oldTeam.rest
  newTeam = _.map newTeam, (member) ->
    if member.role in _.keys roles
      member.role = roles member.role
    else
      if member in oldTeam.dev
        member.role = roles['Developer']
      else
        member.role = roles['Scrum Master']
    member
  project.set 'teamNew', newTeam
  project.save()

# then delete the column in Parse app and create a new one of type array
# query = new (Parse.Query)('Project')
# query.each (project) ->
#   project.set('team', project.get('teamNew'))
#   project.save()
# then delete the teamNew column
