angular.module 'NotSoShitty.problem'
.config ($stateProvider) ->
  $stateProvider
  .state 'tab.problem',
    url: '/project/:projectId'
    template: '<ui-view>'
  .state 'tab.problem.list',
    url: '/problems'
    controller: 'ProblemListCtrl'
    templateUrl: 'problem/states/list/view.html'
    resolve:
      problems: (Problem, $stateParams) ->
        Problem.getByProjectId $stateParams.projectId
  .state 'tab.problem.new',
    url: '/problems/new'
    controller: 'ProblemEditCtrl'
    templateUrl: 'problem/states/edit/view.html'
    resolve:
      problem: (Problem) ->
        new Problem(date: new Date())
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
  .state 'tab.problem.edit',
    url: '/problem/:problemId'
    controller: 'ProblemEditCtrl'
    templateUrl: 'problem/states/edit/view.html'
    resolve:
      problem: (Problem, $stateParams) ->
        Problem.find $stateParams.problemId
      project: (Project, $stateParams) ->
        Project.find $stateParams.projectId
