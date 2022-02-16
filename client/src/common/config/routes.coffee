template = require '../states/base.html'

angular.module 'Scrumble.common'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab',
    abstract: true
    template: template
    controller: 'BaseCtrl'
    resolve:
      sprint: ($state, Sprint) ->
        Sprint.getActiveSprint().catch (err) -> return {}
      project: ($state, Project) ->
        Project.getUserProject()
          .then (project) ->
            # Migrate projects with only one doing colum
            if project?.columnMapping?.doing? && typeof project.columnMapping.doing == 'string'
              project.columnMapping.doing = [project.columnMapping.doing]
            return project
          .catch (err) -> return {}
