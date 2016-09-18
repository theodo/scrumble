angular.module 'Scrumble.problems'
.directive 'problemsList', ->
  restrict: 'E'
  templateUrl: 'problems/components/problems-list/template.html'
  scope:
    projectId: '@'
    organizationId: '@'
    compact: '@'
  controller: ($scope, $mdDialog, Problem, Organization, trelloUtils) ->
    $scope.editable = $scope.projectId?

    $scope.problemClicked = (problem, ev) ->
      $scope.$emit('problem:clicked', problem, ev)

    fetchProjectProblems = ->
      $scope.loading = true
      Problem.query(
        filter:
          where:
            projectId: $scope.projectId
          order: 'happenedDate DESC'
          include: 'tags'
      ).then (problems) ->
        $scope.problems = _.map problems, (problem) ->
          if trelloUtils.isTrelloCardUrl problem.link
            trelloUtils.getCardInfoFromUrl problem.link
            .then (info) ->
              problem.card = info
          problem
        $scope.loading = false

    fetchOrganizationProblems = ->
      $scope.loading = true
      Organization.get(
        organizationId: $scope.organizationId
        filter:
          include:
            projects:
              problems: 'tags'
      ).then (organization) ->
        $scope.problems = _.reduce(organization.projects, (problems, project) ->
          _.map project.problems, (problem) ->
            problem.projectName = project.name
            problem
          problems.concat(project.problems)
        , [])
        $scope.loading = false

    fetchProblems = ->
      if $scope.organizationId?
        fetchOrganizationProblems()

      if $scope.projectId?
        fetchProjectProblems()

    fetchProblems()

    $scope.$on 'problem:saved', ->
      fetchProblems()

    $scope.deleteProblem = (problem, ev) ->
      $mdDialog.show($mdDialog.confirm()
        .title('Are you sure you want to do what you\'re trying to do?')
        .ariaLabel('delete confirm')
        .targetEvent(ev)
        .ok('Yes')
        .cancel('No')
      ).then ->
        Problem.delete(problemId: problem.id).then fetchProblems
