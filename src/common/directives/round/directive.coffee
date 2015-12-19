angular.module('NotSoShitty.common').directive 'nssRound', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, ngModelController) ->
      ngModelController.$parsers.push (data) ->
        #convert data from view format to model format
        parseFloat data
        #converted
      ngModelController.$formatters.push (data) ->
        #convert data from model format to view format
        if _.isNumber data
          data = data.toFixed 1
        data
        #converted
      return

  }
