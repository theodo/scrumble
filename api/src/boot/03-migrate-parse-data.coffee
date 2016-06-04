Promise = require 'bluebird'
_ = require 'lodash'

projects = require('./parse-backup/Project').results
sprints = require('./parse-backup/Sprint').results
dailyReports = require('./parse-backup/DailyReport').results
users = require('./parse-backup/NotSoShittyUser').results

module.exports = (server, next) ->
  # return next()
  Sprint = server.models.Sprint
  Project = server.models.Project
  DailyReport = server.models.DailyReport
  ScrumbleUser = server.models.ScrumbleUser

  generatePassword = (length) ->
    characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = (characters[Math.floor(Math.random() * characters.length)] for i in [1..length])
    result.join()

  insertProjects = ->
    Promise.each projects, (project) ->
      project.name = 'NO NAME' unless project.name?
      return unless project.boardId?
      Project.create(project)

  insertUsers = ->
    Promise.each users, (user) ->
      console.log user.email
      Project.findOne
        where:
          objectId: user.project?.objectId
      .then (project) ->
        if project? and user.project?.objectId?
          user.projectId = project.id
        user.created = user.createdAt
        user.lastupdated = user.updatedAt
        user.emailverified = true
        user.username = user.email
        user.password = generatePassword 100
        ScrumbleUser.create(user)

  insertSprints = ->
    Promise.each sprints, (sprint) ->
      sprint.number = parseInt(sprint.number) or 0
      Project.findOne
        where:
          objectId: sprint.project.objectId
      .then (project) ->
        if project?
          sprint.projectId = project.id
          Sprint.create sprint
        else
          console.log "Warning: project not found for sprint #{sprint.objectId}"

  insertDailyReports = ->
    Promise.each dailyReports, (daily) ->
      Project.findOne
        where:
          objectId: daily.project.objectId
      .then (project) ->
        if project?
          daily.projectId = project.id
          DailyReport.create daily
        else
          console.log "Warning: project not found for daily #{daily.objectId}"

  Sprint.deleteAll()
  .then ->
    console.log 'users deleted'
    ScrumbleUser.deleteAll()
  .then ->
    console.log 'sprints deleted'
    DailyReport.deleteAll()
  .then ->
    console.log 'daily reports deleted'
    Project.deleteAll()
  .then ->
    console.log 'projects deleted'
    insertProjects()
  .then ->
    console.log 'users deleted'
    insertUsers()
  .then ->
    console.log 'projects inserted'
    insertSprints()
  .then ->
    console.log 'sprints inserted'
    insertDailyReports()
  .then ->
    next()
  .catch (err) ->
    console.error err
    next(err)
