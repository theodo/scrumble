angular.module 'Scrumble.login'
.directive 'profilInfo', ->
  restrict: 'E'
  templateUrl: 'login/directives/profil-info/view.html'
  scope: {}
  controller: 'ProfilInfoCtrl'
