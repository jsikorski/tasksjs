'use strict'


angular.module 'tasksjsApp'
  .directive 'focusWhen', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      scope.$watch attrs.focusWhen, (value) ->
        _.delay(-> element[0].focus()) if value