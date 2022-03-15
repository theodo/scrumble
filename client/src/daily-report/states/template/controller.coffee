require './style.less'
import DOMPurify from 'dompurify';


angular.module 'Scrumble.daily-report'
.directive "fileread",  () ->
    {
        scope: {
            fileread: "="
        },
        link: (scope, element, attributes) ->
            element.bind("change", (changeEvent) ->
                reader = new FileReader();
                reader.onload = (loadEvent) ->
                    scope.$apply(() ->
                        sanitizedTitle = DOMPurify.sanitize(changeEvent.target.files[0].name)
                        fileExtension = sanitizedTitle.substring(sanitizedTitle.length - 4, sanitizedTitle.length)
                        filename = if sanitizedTitle.length > 17 then (sanitizedTitle.substring(0, 10) + '...' +  fileExtension) else sanitizedTitle
                        scope.fileread =
                          raw: loadEvent.target.result
                          name: filename
                          localUrl: URL.createObjectURL(changeEvent.target.files[0])
                    );
                reader.readAsDataURL(changeEvent.target.files[0])
            );
    }
.controller 'DailyReportCtrl', ['$scope', '$state', '$mdToast', '$mdDialog', '$mdMedia', '$document', 'reportBuilder', 'DailyReport', 'dailyReport', 'dailyCache', (
  $scope
  $state
  $mdToast
  $mdDialog
  $mdMedia
  $document
  reportBuilder
  DailyReport
  dailyReport
  dailyCache
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top left')
    .content('Saved!')
    .parent($document[0].querySelector('main'))

  # If the daily report is in cache, use it
  sections = dailyCache.get 'sections'
  if sections?
    dailyReport.sections = sections
    $scope.sections = dailyReport.sections
  else
    dailyReport.sections ?= {}
    $scope.sections = dailyReport.sections
    dailyReportToCache = $scope.sections

    # Don't cache progressImage
    dailyReportToCache.progressImage = undefined
    dailyReportToCache.progressImage2 = undefined
    dailyReportToCache.progressImage3 = undefined
    dailyCache.put 'sections', $scope.sections

  $scope.save = (ev) ->
    DailyReport.save(dailyReport).then ->
      $mdToast.show saveFeedback

  $scope.$on(
     '$stateChangeStart',
    (event, next, current) ->
      console.log
      if $scope.daily.$dirty and !confirm("Are you sure that you want to leave this page?")
        event.preventDefault()
    );

  window.onbeforeunload = () ->
    "Are you sure that you want to leave this page?"
  $scope.$on('$destroy', () ->
    window.onbeforeunload = undefined;
  )

  $scope.preview = (ev) ->
    $mdDialog.show
      controller: 'PreviewCtrl'
      template: require('../preview/view.html')
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        message: ->
          reportBuilder.render(
            $scope.sections
            dailyReport
            d3.select('#bdcgraph')[0][0].firstChild
            $scope.project
            $scope.sprint
          )
        dailyReport: -> dailyReport
        todaysGoals: -> $scope.sections.todaysGoals
        sprint: -> $scope.sprint
]