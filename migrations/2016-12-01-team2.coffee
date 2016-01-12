_ = require('underscore')
Parse = require('parse/node').Parse
Parse.initialize 'UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG', 'c8v3Y5mg7VEnNN5u1encLS1GKqsqEWC1vZOYLmQb', 'yLM0zIxaICtwlpPtp4YokCQwo1Z3WrESzH44GzN6'
Parse.Cloud.useMasterKey()


query = new (Parse.Query)('Project')
query.each (project) ->
  console.log 'About project: ' + project.id

  team = project.get('team') or []
  newTeam = []
  for member in team
    if member.role?
      member.role = member.role.value
    newTeam.push member
  project.set 'team', newTeam
  project.save()
