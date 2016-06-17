angular.module 'Scrumble.models'
.service 'Feedback', ($resource, $q, $http, API_URL) ->
  endpoint = "#{API_URL}/Feedbacks"
  Feedback = $resource(
    "#{endpoint}/:feedbackId",
    {feedbackId: '@id'}
  )

  new: ->
    new Feedback()
  get: (parameters, success, error) ->
    Feedback.get(parameters, success, error).$promise
