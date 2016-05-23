Promise = require 'bluebird'
_ = require 'lodash'

# projects = require '../../data/Project'
# sprints = require '../../data/Sprint'
# dailyReports = require '../../data/DailyReport'

module.exports = (server, next) ->
  next()
  # Sprint = server.models.Sprint
  # Project = server.models.Project
  # DailyReport = server.models.DailyReport
  #
  # insertProjects = ->
  #   Project.deleteAll().then ->
  #     for project in projects
  #       project.name = 'NO NAME' unless project.name?
  #     projects = _.filter projects, (project) ->
  #       project.boardId?
  #     inserts = (Project.create(project) for project in projects)
  #     Promise.all(inserts)
  #
  # insertSprints = ->
  #   Promise.each sprints, (sprint) ->
  #     sprint.number = 0 unless _.isNumber sprint.number
  #     Project.findOne
  #       where:
  #         objectId: sprint.project.objectId
  #     .then (project) ->
  #       if project?
  #         sprint.projectId = project.id
  #         Sprint.create sprint
  #       else
  #         console.log "Warning: project not found for sprint #{sprint.objectId}"
  #
  # insertDailyReports = ->
  #   Promise.each dailyReports, (daily) ->
  #     Project.findOne
  #       where:
  #         objectId: daily.project.objectId
  #     .then (project) ->
  #       if project?
  #         daily.projectId = project.id
  #         DailyReport.create daily
  #       else
  #         console.log "Warning: project not found for daily #{daily.objectId}"
  #
  # Sprint.deleteAll()
  # .then ->
  #   console.log 'sprints deleted'
  #   DailyReport.deleteAll()
  # .then ->
  #   console.log 'daily reports deleted'
  #   Project.deleteAll()
  # .then ->
  #   console.log 'projects deleted'
  #   insertProjects()
  # .then ->
  #   console.log 'projects inserted'
  #   insertSprints()
  # .then ->
  #   console.log 'sprints inserted'
  #   insertDailyReports()
  # .then ->
  #   next()
  # .catch (err) ->
  #   console.error err
  #   next(err)
