template = require './view.html'

angular.module 'Scrumble.login'
.directive 'profilInfo', ->
  restrict: 'E'
  template: template
  scope: {}
  controller: 'ProfilInfoCtrl'
