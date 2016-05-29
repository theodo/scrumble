angular.module 'Scrumble.models'
.service 'Project', ($resource, $http, API_URL) ->
  endpoint = "#{API_URL}/Projects"
  Project = $resource(
    "#{endpoint}/:projectId:action",
    {projectId: '@id'},
    getUserProject:
      method: 'GET'
      params:
        action: 'current'
    update:
      method: 'PUT'
  )

  new: ->
    new Project()
  find: Project.find
  query: Project.query
  get: (parameters, success, error) ->
    Project.get(parameters, success, error).$promise
  getUserProject: ->
    Project.getUserProject().$promise
  update: Project.update
  getLastSpeeds: (projectId) ->
    $http.get("#{endpoint}/#{projectId}/last-speeds")
  saveTitle: (project, title) ->
    project.settings ?= {}
    project.settings.bdcTitle = title
    project.save().then ->
      title
