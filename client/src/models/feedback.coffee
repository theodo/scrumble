angular.module 'Scrumble.models'
.service 'Feedback', ['$resource', '$q', '$http', ($resource, $q, $http) ->
  endpoint = "#{API_URL}/Feedbacks"
  Feedback = $resource(
    "#{endpoint}/:feedbackId",
    {feedbackId: '@id'},
    update:
      method: 'PUT'
  )

  new: ->
    new Feedback()
  get: (parameters, success, error) ->
    Feedback.get(parameters, success, error).$promise
  find: (parameters, success, error) ->
    Feedback.query(parameters, success, error).$promise
]