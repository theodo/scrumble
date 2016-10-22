Promise = require 'bluebird'
users = require '../fixtures/scrumble-users'
organizations = require '../fixtures/organizations'
boardGroups = require '../fixtures/board-groups'
projects = require '../fixtures/projects'

loadUser = (app, user) ->
  ScrumbleUser = app.models.ScrumbleUser
  AccessToken = app.models.AccessToken

  ScrumbleUser.create(user).then (savedUser) ->
    Promise.each user.accessTokens, (token) ->
      AccessToken.create({id: token, userId: savedUser.id})

loadUsers = (app) ->
  Promise.each users, (user) ->
    loadUser(app, user)

loadProjects = (app) ->
  Promise.each projects, (project) ->
    loadProject(app, project)

loadOrganizations = (app) ->
  Organization = app.models.Organization

  Promise.each organizations, (organization) ->
    Organization.create organization

loadGroups = (app) ->
  Promise.each boardGroups, (boardGroup) ->
    loadGroup(app, boardGroup)

loadGroup = (app, boardGroup) ->
  BoardGroup = app.models.BoardGroup
  app.models.ScrumbleUser.findOne(where: username: boardGroup.username)
  .then (user) ->
    boardGroup.userId = user.id
    BoardGroup.create(boardGroup)

loadProject = (app, project) ->
  Project = app.models.Project
  Sprint = app.models.Sprint
  Problem = app.models.Problem

  Project.create(project).then (savedProject) ->
    insertSprintsPromise = null
    if project.sprints?
      insertSprintsPromise = Promise.each project.sprints, (sprint) ->
        sprint.projectId = savedProject.id
        Sprint.create(sprint)

    insertProblemsPromise = null
    if project.problems?
      insertProblemsPromise = Promise.each project.problems, (problem) ->
        problem.projectId = savedProject.id
        Problem.create(problem)

    Promise.all [insertSprintsPromise, insertProblemsPromise]
    .then ->
      savedProject.id

module.exports =
  loadAll: (app) ->
    loadUsers(app).then ->
      loadOrganizations(app)
    .then ->
      loadProjects(app)
    .then ->
      loadGroups(app)

  deleteAll: (app) ->
    app.models.BoardGroup.deleteAll()
    .then ->
      app.models.AccessToken.deleteAll()
    .then ->
      app.models.ScrumbleUser.deleteAll()
    .then ->
      app.models.Sprint.deleteAll()
    .then ->
      app.models.Problem.deleteAll()
    .then ->
      app.models.Project.deleteAll()
    .then ->
      app.models.Organization.deleteAll()
    .catch (err) ->
      console.error err
  loadUser: loadUser
  loadProject: loadProject
  loadGroup: loadGroup
