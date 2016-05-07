angular.module 'Scrumble.daily-report'
.service 'dailyCache', ($cacheFactory) ->
  $cacheFactory 'daily'
