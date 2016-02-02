angular.module 'Scrumble.indicators'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.indicators',
    url: '/sprint/:sprintId/indicators'
    templateUrl: 'indicators/states/base/view.html'
    controller: 'IndicatorsCtrl'
    resolve:
      currentSprint: (Sprint, $stateParams) ->
        Sprint.find $stateParams.sprintId
      satisfactionSurveyTemplates: (SatisfactionSurveyTemplate) ->
        SatisfactionSurveyTemplate.query()
  .state 'tab.project-dashboard',
    url: '/project/:projectId/indicators'
    templateUrl: 'indicators/states/project-dashboard/view.html'
    controller: 'ProjectIndicatorsCtrl'
    resolve:
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
      sprints: (Sprint, $stateParams) ->
        Sprint.getByProjectId $stateParams.projectId
