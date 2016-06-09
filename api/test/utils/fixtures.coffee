Promise = require 'bluebird'
users = require '../fixtures/scrumble-users'
organizations = require '../fixtures/organizations'

loadUser = (app, user) ->
  ScrumbleUser = app.models.ScrumbleUser
  AccessToken = app.models.AccessToken

  ScrumbleUser.create(user).then (savedUser) ->
    Promise.each user.accessTokens, (token) ->
      AccessToken.create({id: token, userId: savedUser.id})

loadUsers = (app) ->
  Promise.each users, (user) ->
    loadUser(app, user)

loadOrganizations = (app) ->
  Organization = app.models.Organization

  Promise.each organizations, (organization) ->
    Organization.create organization

loadProject = (app, project) ->
  Project = app.models.Project
  Sprint = app.models.Sprint

  Project.create(project).then (savedProject) ->
    Promise.each project.sprints, (sprint) ->
      sprint.projectId = savedProject.id
      Sprint.create(sprint)
    .then ->
      savedProject.id

module.exports =
  loadAll: (app) ->
    loadUsers(app).then ->
      loadOrganizations(app)

  deleteAll: (app) ->
    app.models.AccessToken.deleteAll().then ->
      app.models.ScrumbleUser.deleteAll()
    .then ->
      app.models.Sprint.deleteAll()
    .then ->
      app.models.Project.deleteAll()
    .then ->
      app.models.Organization.deleteAll()
    .catch (err) ->
      console.error err
  loadUser: loadUser
  loadProject: loadProject
